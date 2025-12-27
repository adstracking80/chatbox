<?php

namespace Chatbox;

/**
 * Lightweight helpers for request parsing and auth stubs.
 */

function json_input(): array
{
    $raw = file_get_contents('php://input');
    if (!$raw) {
        return [];
    }
    $data = json_decode($raw, true);
    return is_array($data) ? $data : [];
}

function bearer_token(): ?string
{
    $hdr = $_SERVER['HTTP_AUTHORIZATION'] ?? '';
    if (stripos($hdr, 'Bearer ') === 0) {
        return trim(substr($hdr, 7));
    }
    return null;
}
