<?php

namespace Chatbox\Controllers;
use function Chatbox\json_input;

class AuthController
{
    public function userLogin(): void
    {
        $payload = json_input();
        // TODO: validate $payload['email'], $payload['password'], then issue JWT/session
        Response::json([
            'token' => 'user-jwt-placeholder',
            'role' => 'user',
            'note' => 'Replace with real authentication and password hashing.',
        ]);
    }

    public function adminLogin(): void
    {
        $payload = json_input();
        // TODO: validate owner/admin credentials
        Response::json([
            'token' => 'admin-jwt-placeholder',
            'role' => 'admin',
            'note' => 'Replace with real authentication and password hashing.',
        ]);
    }
}
