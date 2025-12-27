<?php

use Chatbox\Controllers\AuthController;
use Chatbox\Controllers\ChatController;
use Chatbox\Controllers\AdminController;
use Chatbox\Controllers\Response;

$method = $_SERVER['REQUEST_METHOD'] ?? 'GET';
$path = parse_url($_SERVER['REQUEST_URI'] ?? '/', PHP_URL_PATH);

// Very small router. Replace with a full micro-framework as you scale.
$routes = [
    ['POST', '/auth/login', [new AuthController(), 'userLogin']],
    ['POST', '/auth/admin/login', [new AuthController(), 'adminLogin']],
    ['POST', '/session', [new ChatController(), 'createSession']],
    ['POST', '/messages', [new ChatController(), 'postMessage']],
    ['GET', '/messages', [new ChatController(), 'listMessages']],
    ['GET', '/admin/conversations', [new AdminController(), 'listConversations']],
    ['POST', '/admin/messages', [new AdminController(), 'postMessage']],
    ['POST', '/admin/conversations/status', [new AdminController(), 'updateConversationStatus']],
    ['GET', '/admin/export.csv', [new AdminController(), 'exportCsv']],
    ['GET', '/health', function () { Response::json(['status' => 'ok']); }],
];

foreach ($routes as [$verb, $routePath, $handler]) {
    if ($method === $verb && $path === $routePath) {
        if (is_callable($handler)) {
            $handler();
        } elseif (is_array($handler) && is_callable($handler)) {
            call_user_func($handler);
        }
        exit;
    }
}

Response::json(['error' => 'Not Found', 'path' => $path], 404);
