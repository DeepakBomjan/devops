<?php
require_once "./app/Database.php";

class Todo extends Database
{
    public function getTodos($limit)
    {
        return $this->select("SELECT * FROM todos LIMIT $limit");
    }

    public function updateTodo($id, $todo)
    {
        // Sanitize inputs to prevent SQL injection
        $id = $this->sanitize($id);
        $todo = $this->sanitize($todo);

        // Prepare the update query
        $sql = "UPDATE todos SET todo = '$todo' WHERE id = $id";

        // Execute the update query
        $result = $this->execute($sql);

        // Check if the update was successful
        if ($result) {
            return true; // Return true if update was successful
        } else {
            return false; // Return false if update failed
        }
    }
}
?>