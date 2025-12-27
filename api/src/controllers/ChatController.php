<?php

namespace Chatbox\Controllers;
use function Chatbox\json_input;
use function Chatbox\bearer_token;

class ChatController
{
    public function createSession(): void
    {
        $payload = json_input();
        // TODO: validate contact/anonymous and attribution (gclid/fbclid/UTM), persist to DB.
        Response::json([
            'conversationId' => rand(1000, 9999),
            'sessionToken' => 'session-token-placeholder',
            'message' => 'Session created (placeholder). Persist to DB in production.',
        ], 201);
    }

    public function postMessage(): void
    {
        $token = bearer_token();
        if (!$token) {
            Response::error('Missing bearer token', 401);
        }
        $payload = json_input();
        // TODO: validate and persist message.
        Response::json([
            'status' => 'ok',
            'message' => 'Message accepted (placeholder).',
        ]);
    }

    public function listMessages(): void
    {
        // Return paginated conversation history (placeholder data).
        Response::json([
            'conversationId' => $_GET['conversationId'] ?? null,
            'messages' => [
                ['sender' => 'user', 'body' => 'Hello', 'at' => date(DATE_ATOM)],
            ],
        ]);
    }
}
