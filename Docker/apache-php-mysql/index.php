<?php
// Set the response content type to JSON
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: http://3.82.103.188:3000');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');

// Include configuration and Todo class
require_once "./app/config.php";
require_once "./app/todos.php";

// Check if the request method is OPTIONS (preflight request for CORS)
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    // Return 200 OK status for preflight requests
    http_response_code(200);
    exit();
}

// Check if the request method is GET
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    // Create an instance of the Todo class
    $todoModel = new Todo();

    // Fetch todos
    $response = $todoModel->getTodos(10);

    // Encode the response array as JSON
    $jsonResponse = json_encode($response);

    // Output the JSON response
    echo $jsonResponse;
}
// Check if the request method is POST
elseif ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Read JSON data from the request body
    $data = json_decode(file_get_contents('php://input'), true);

    // Check if data is valid
    if (isset($data['id']) && isset($data['todo'])) {
        // Create an instance of the Todo class
        $todoModel = new Todo();

        // Update the todo
        $updateSuccess = $todoModel->updateTodo($data['id'], $data['todo']);

        // Prepare the response
        $response = ['success' => $updateSuccess];

        // Encode the response array as JSON
        $jsonResponse = json_encode($response);

        // Output the JSON response
        echo $jsonResponse;
    } else {
        // Invalid request data
        http_response_code(400); // Bad Request
        echo json_encode(['error' => 'Invalid request data']);
    }
}
// Invalid request method
else {
    http_response_code(405); // Method Not Allowed
    echo json_encode(['error' => 'Method not allowed']);
}
?>
