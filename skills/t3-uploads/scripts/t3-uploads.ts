#!/usr/bin/env bun

import { realpathSync } from "node:fs"
import { basename } from "node:path"

const MAX_BYTES = 100 * 1024 * 1024
const EXPIRE_SECONDS = 172_800
const UPLOAD_URL = "https://tmpfiles.org/api/v1/upload"

function fail(message: string): never {
  throw new Error(message)
}

function getFilePath(args: string[]): string {
  if (args.length !== 2 || args[0] !== "--file" || !args[1]) {
    return fail("Usage: t3-uploads.ts --file /absolute/path/to/file")
  }
  return realpathSync(args[1])
}

async function main(): Promise<void> {
  const filePath = getFilePath(process.argv.slice(2))
  const file = Bun.file(filePath)
  if (file.size > MAX_BYTES) fail(`tmpfiles.org accepts at most ${MAX_BYTES} bytes per file`)

  const form = new FormData()
  form.append("file", file, basename(filePath))
  form.append("expire", String(EXPIRE_SECONDS))

  const response = await fetch(UPLOAD_URL, {
    method: "POST",
    headers: { accept: "application/json", "x-requested-with": "XMLHttpRequest" },
    body: form,
    signal: AbortSignal.timeout(300_000),
  })
  const responseText = await response.text()
  if (!response.ok) fail(`tmpfiles.org upload failed with HTTP ${response.status}: ${responseText.slice(0, 500)}`)

  let value: unknown
  try {
    value = JSON.parse(responseText)
  } catch {
    return fail("tmpfiles.org returned invalid JSON; do not retry automatically")
  }
  if (!value || typeof value !== "object" || !("data" in value) || !value.data || typeof value.data !== "object"
    || !("url" in value.data) || typeof value.data.url !== "string") {
    return fail("tmpfiles.org returned no file URL; do not retry automatically")
  }

  const landingUrl = new URL(value.data.url)
  if (landingUrl.protocol !== "https:" || landingUrl.hostname !== "tmpfiles.org") {
    return fail("tmpfiles.org returned an unexpected file URL; do not retry automatically")
  }
  const landingResponse = await fetch(landingUrl, {
    headers: { accept: "text/html" },
    signal: AbortSignal.timeout(30_000),
  })
  if (!landingResponse.ok) fail(`tmpfiles.org file page failed with HTTP ${landingResponse.status}`)

  const landingHtml = await landingResponse.text()
  const directMatch = landingHtml.match(/href=["'](https:\/\/tmpfiles\.org\/dl\/[^"']+)["']/i)
  if (!directMatch?.[1]) fail("tmpfiles.org returned no direct-download URL; do not retry automatically")
  const directUrl = new URL(directMatch[1].replaceAll("&amp;", "&"))
  if (directUrl.hostname !== "tmpfiles.org" || !directUrl.pathname.startsWith("/dl/")) {
    return fail("tmpfiles.org returned an unexpected direct-download URL; do not retry automatically")
  }

  const uploadedAt = new Date()
  process.stdout.write(`${JSON.stringify({
    name: basename(filePath),
    sizeBytes: file.size,
    directUrl: directUrl.toString(),
    expiresAt: new Date(uploadedAt.getTime() + EXPIRE_SECONDS * 1_000).toISOString(),
  }, null, 2)}\n`)
}

try {
  await main()
} catch (error) {
  process.stderr.write(`${error instanceof Error ? error.message : String(error)}\n`)
  process.exitCode = 1
}
