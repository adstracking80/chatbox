<?php

// Copy to config.php and fill your values.
return [
    'db' => [
        'host' => 'localhost',
        'name' => 'chatbox',
        'user' => 'db_user',
        'pass' => 'db_pass',
        'charset' => 'utf8mb4',
    ],
    'jwt' => [
        'secret' => 'replace-with-strong-secret',
        'issuer' => 'chatbox.adsandtracking.com',
        'audience' => 'chatbox.adsandtracking.com',
        'ttl_seconds' => 86400,
    ],
    'cors' => [
        'allowed_origins' => ['https://adsandtracking.com', 'https://chatbox.adsandtracking.com'],
    ],
    'app' => [
        'allow_anonymous_chat' => false,
    ],
];
