<?php

namespace Chatbox;

// Minimal bootstrap for dependency loading and routing.
// Inspired by Laravel-style separation (see krayin/laravel-crm), but simplified for cPanel.

class App
{
    public function run(): void
    {
        $config = $this->loadConfig();

        // Load helpers and controllers
        require_once __DIR__ . '/helpers.php';
        require_once __DIR__ . '/controllers/Response.php';
        require_once __DIR__ . '/controllers/AuthController.php';
        require_once __DIR__ . '/controllers/ChatController.php';
        require_once __DIR__ . '/controllers/AdminController.php';

        // Pass config down if needed by controllers/services.
        $GLOBALS['chatbox_config'] = $config;

        $this->applyCors($config);

        // Handle preflight early.
        if (strtoupper($_SERVER['REQUEST_METHOD'] ?? '') === 'OPTIONS') {
            http_response_code(204);
            exit;
        }

        require_once __DIR__ . '/routes.php';
    }

    private function loadConfig(): array
    {
        $configFile = __DIR__ . '/../config/config.php';
        $exampleFile = __DIR__ . '/../config/config.example.php';

        if (file_exists($configFile)) {
            return require $configFile;
        }

        if (file_exists($exampleFile)) {
            return require $exampleFile;
        }

        return [
            'db' => [
                'host' => 'localhost',
                'name' => '',
                'user' => '',
                'pass' => '',
                'charset' => 'utf8mb4',
            ],
            'jwt' => [
                'secret' => 'set-a-secret',
                'issuer' => 'chatbox.adsandtracking.com',
                'audience' => 'chatbox.adsandtracking.com',
                'ttl_seconds' => 86400,
            ],
            'cors' => [
                'allowed_origins' => ['*'],
            ],
            'app' => [
                'allow_anonymous_chat' => false,
            ],
        ];
    }

    private function applyCors(array $config): void
    {
        $origins = $config['cors']['allowed_origins'] ?? ['*'];
        $origin = $_SERVER['HTTP_ORIGIN'] ?? '';
        if (in_array('*', $origins, true) || in_array($origin, $origins, true)) {
            header('Access-Control-Allow-Origin: ' . ($origin ?: '*'));
            header('Vary: Origin');
        }
        header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
        header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Public-Key');
    }
}
