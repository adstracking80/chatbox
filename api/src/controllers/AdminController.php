<?php

namespace Chatbox\Controllers;
use function Chatbox\json_input;
use function Chatbox\bearer_token;

class AdminController
{
    public function listConversations(): void
    {
        $token = bearer_token();
        if (!$token) {
            Response::error('Missing admin token', 401);
        }
        // Add filtering by status, lead_status, source/campaign in production.
        Response::json([
            'items' => [
                [
                    'id' => 1,
                    'lead_status' => 'new',
                    'contact_email' => 'demo@example.com',
                    'source' => 'utm_campaign_placeholder',
                ],
            ],
            'filters' => $_GET,
        ]);
    }

    public function postMessage(): void
    {
        $token = bearer_token();
        if (!$token) {
            Response::error('Missing admin token', 401);
        }
        $payload = json_input();
        // TODO: validate and persist reply.
        Response::json([
            'status' => 'ok',
            'message' => 'Agent reply accepted (placeholder).',
        ]);
    }

    public function updateConversationStatus(): void
    {
        $token = bearer_token();
        if (!$token) {
            Response::error('Missing admin token', 401);
        }
        $payload = json_input();
        // Expect: status (open/closed) and lead_status transitions.
        Response::json([
            'status' => 'ok',
            'message' => 'Conversation status updated (placeholder).',
        ]);
    }

    public function exportCsv(): void
    {
        $rows = [
            ['conversation_id', 'lead_status', 'email', 'gclid', 'fbclid', 'utm_source', 'utm_campaign'],
            [1, 'new', 'demo@example.com', 'gclid-123', 'fbclid-456', 'google', 'spring_campaign'],
        ];
        Response::csv('conversations_export.csv', $rows);
    }
}
