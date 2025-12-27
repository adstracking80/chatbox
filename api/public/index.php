<?php
// Entry point for the API. Lightweight router bootstrap.

require_once __DIR__ . '/../src/bootstrap.php';

use Chatbox\App;

$app = new App();
$app->run();
