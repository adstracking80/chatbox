<?php

namespace Chatbox\Controllers;

class Response
{
    public static function json(array $data, int $code = 200): void
    {
        http_response_code($code);
        header('Content-Type: application/json');
        echo json_encode($data);
        exit;
    }

    public static function error(string $message, int $code = 400, array $extra = []): void
    {
        $body = array_merge(['error' => $message], $extra);
        self::json($body, $code);
    }

    public static function csv(string $filename, array $rows): void
    {
        header('Content-Type: text/csv');
        header('Content-Disposition: attachment; filename="' . $filename . '"');
        $out = fopen('php://output', 'w');
        foreach ($rows as $row) {
            fputcsv($out, $row);
        }
        fclose($out);
        exit;
    }
}
