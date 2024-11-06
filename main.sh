#!/bin/bash

# To-do list file
TODO_FILE="$HOME/todo.txt"

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to display the menu
show_menu() {
  echo -e "${YELLOW}1) View To-Do List${NC}"
  echo -e "${YELLOW}2) Add Task${NC}"
  echo -e "${YELLOW}3) Remove Task${NC}"
  echo -e "${YELLOW}4) Mark Task as Done${NC}"
  echo -e "${YELLOW}5) Undo Mark as Done${NC}"
  echo -e "${YELLOW}6) Sort Tasks by Priority${NC}"
  echo -e "${YELLOW}7) Search Tasks${NC}"
  echo -e "${YELLOW}8) Show Statistics and Insights${NC}"
  echo -e "${YELLOW}9) Filter Tasks by Tag${NC}"
  echo -e "${YELLOW}10) Exit${NC}"
}

# Function to view tasks
view_tasks() {
  if [ -f "$TODO_FILE" ]; then
    echo -e "${GREEN}Your To-Do List:${NC}"
    nl -w 2 -s ". " "$TODO_FILE"
  else
    echo -e "${RED}No tasks yet!${NC}"
  fi
}

# Function to add a task with a reminder and tags
add_task() {
  if [ ! -f "$TODO_FILE" ]; then
    touch "$TODO_FILE"
  fi
  echo -n "Enter a new task: "
  read task
  echo -n "Set priority (Low, Medium, High): "
  read priority
  echo -n "Set deadline (YYYY-MM-DD): "
  read deadline
  echo -n "Set reminder (HH:MM, 24-hour format, leave empty if not needed): "
  read reminder_time
  echo -n "Enter tags for the task (e.g., work, personal): "
  read tags

  # Save the task in the todo file
  echo "[$priority] $task - Due: $deadline #$tags" >> "$TODO_FILE"
  echo -e "${GREEN}Task added with priority, deadline, and tags!${NC}"

  # Schedule reminder if time is provided
  if [ -n "$reminder_time" ]; then
    echo "notify-send 'Reminder: $task'" | at $reminder_time
    echo -e "${GREEN}Reminder set for $reminder_time!${NC}"
  fi
}

# Function to remove a task
remove_task() {
  if [ -f "$TODO_FILE" ]; then
    view_tasks
    echo -n "Enter task number to remove: "
    read task_number
    sed -i "${task_number}d" "$TODO_FILE"
    echo -e "${GREEN}Task removed!${NC}"
  else
    echo -e "${RED}No tasks to remove!${NC}"
  fi
}

# Function to mark a task as done
mark_done() {
  if [ -f "$TODO_FILE" ]; then
    view_tasks
    echo -n "Enter task number to mark as done: "
    read task_number
    sed -i "${task_number}s/^/[DONE] /" "$TODO_FILE"
    echo -e "${GREEN}Task marked as done!${NC}"
  else
    echo -e "${RED}No tasks to mark!${NC}"
  fi
}

# Function to undo marking a task as done
undo_done() {
  if [ -f "$TODO_FILE" ]; then
    view_tasks
    echo -n "Enter task number to undo: "
    read task_number
    sed -i "${task_number}s/^\[DONE\] //" "$TODO_FILE"
    echo -e "${GREEN}Task status undone!${NC}"
  else
    echo -e "${RED}No tasks to undo!${NC}"
  fi
}

# Function to sort tasks by priority
sort_tasks() {
  if [ -f "$TODO_FILE" ]; then
    echo -e "${GREEN}Sorted Tasks:${NC}"
    grep "\[High\]" "$TODO_FILE"
    grep "\[Medium\]" "$TODO_FILE"
    grep "\[Low\]" "$TODO_FILE"
  else
    echo -e "${RED}No tasks to sort!${NC}"
  fi
}

# Function to search tasks
search_tasks() {
  echo -n "Enter a keyword to search: "
  read keyword
  grep -i "$keyword" "$TODO_FILE" || echo -e "${RED}No tasks found with keyword: $keyword${NC}"
}

# Function to show statistics and insights
show_stats() {
  if [ -f "$TODO_FILE" ]; then
    total_tasks=$(wc -l < "$TODO_FILE")
    completed_tasks=$(grep -c "^\[DONE\]" "$TODO_FILE")
    pending_tasks=$((total_tasks - completed_tasks))
    high_priority=$(grep -c "\[High\]" "$TODO_FILE")
    medium_priority=$(grep -c "\[Medium\]" "$TODO_FILE")
    low_priority=$(grep -c "\[Low\]" "$TODO_FILE")

    echo -e "${GREEN}Statistics and Insights:${NC}"
    echo -e "${GREEN}Total tasks: $total_tasks${NC}"
    echo -e "${GREEN}Completed tasks: $completed_tasks${NC}"
    echo -e "${GREEN}Pending tasks: $pending_tasks${NC}"
    echo -e "${GREEN}High priority tasks: $high_priority${NC}"
    echo -e "${GREEN}Medium priority tasks: $medium_priority${NC}"
    echo -e "${GREEN}Low priority tasks: $low_priority${NC}"
  else
    echo -e "${RED}No tasks to show stats for!${NC}"
  fi
}

# Function to filter tasks by tag
filter_by_tag() {
  if [ -f "$TODO_FILE" ]; then
    echo -n "Enter tag to filter: "
    read tag
    grep "#$tag" "$TODO_FILE" || echo -e "${RED}No tasks found with tag: $tag${NC}"
  else
    echo -e "${RED}No tasks to filter!${NC}"
  fi
}

# Main loop
while true; do
  show_menu
  echo -n "Choose an option: "
  read choice
  case $choice in
    1) view_tasks ;;
    2) add_task ;;
    3) remove_task ;;
    4) mark_done ;;
    5) undo_done ;;
    6) sort_tasks ;;
    7) search_tasks ;;
    8) show_stats ;;
    9) filter_by_tag ;;
    10) echo -e "${GREEN}Goodbye!${NC}"; exit ;;
    *) echo -e "${RED}Invalid option! Please try again.${NC}" ;;
  esac
done
