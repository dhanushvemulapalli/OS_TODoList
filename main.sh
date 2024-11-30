#!/bin/bash

# To-do list file
TODO_FILE="$HOME/todo.txt"

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display the menu
show_menu() {
  echo -e "${BLUE}1) View To-Do List${NC}"
  echo -e "${BLUE}2) Add Task${NC}"
  echo -e "${BLUE}3) Remove Task${NC}"
  echo -e "${BLUE}4) Mark Task as Done${NC}"
  echo -e "${BLUE}5) Undo Mark as Done${NC}"
  echo -e "${BLUE}6) Sort Tasks by Priority${NC}"
  echo -e "${BLUE}7) Search Tasks${NC}"
  echo -e "${BLUE}8) Show Statistics and Insights${NC}"
  echo -e "${BLUE}9) Filter Tasks by Tag${NC}"
  echo -e "${BLUE}10) Export Tasks(press e) ${NC}"
  echo -e "${BLUE}11) Import Tasks (press i) ${NC}"
  echo -e "${BLUE}12) Exit (press x) ${NC}"
  echo -e "${GREEN}Press the corresponding number to choose an option.${NC}"
}

# Function to color-code tasks based on priority
view_tasks() {
  if [ -f "$TODO_FILE" ]; then
    echo -e "${GREEN}Your To-Do List:${NC}"
    while read -r line; do
      if [[ "$line" == *"[High]"* ]]; then
        echo -e "${RED}$line${NC}"
      elif [[ "$line" == *"[Medium]"* ]]; then
        echo -e "${YELLOW}$line${NC}"
      else
        echo -e "${GREEN}$line${NC}"
      fi
    done < "$TODO_FILE"
  else
    echo -e "${RED}No tasks yet!${NC}"
  fi
}

# Function to add a task
add_task() {
  if [ ! -f "$TODO_FILE" ]; then
    touch "$TODO_FILE"
  fi
  echo -n "Enter a new task: "
  read task

  echo -e "${YELLOW}Set priority:${NC}"
  echo -e "${GREEN}1) Low${NC}"
  echo -e "${YELLOW}2) Medium${NC}"
  echo -e "${RED}3) High${NC}"
  echo -n "Choose priority (press 1, 2, or 3): "
  read -n 1 -s priority_choice
  echo

  case $priority_choice in
    1) priority="Low" ;;
    2) priority="Medium" ;;
    3) priority="High" ;;
    *) echo -e "${RED}Invalid choice! Defaulting to 'Low'.${NC}"; priority="Low" ;;
  esac

  echo -n "Set deadline (YYYY-MM-DD): "
  read deadline
  echo -n "Enter tags for the task (e.g., work, personal): "
  read tags

  echo "[$priority] $task - Due: $deadline #$tags" >> "$TODO_FILE"
  echo -e "${GREEN}Task added!${NC}"
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

# Function to export tasks
export_tasks() {
  echo -n "Enter export file name: "
  read export_file
  cp "$TODO_FILE" "$export_file"
  echo -e "${GREEN}Tasks exported to $export_file.${NC}"
}

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

filter_by_tag() {
  if [ -f "$TODO_FILE" ]; then
    echo -n "Enter tag to filter: "
    read tag
    grep "#$tag" "$TODO_FILE" || echo -e "${RED}No tasks found with tag: $tag${NC}"
  else
    echo -e "${RED}No tasks to filter!${NC}"
  fi
}

# Function to import tasks
import_tasks() {
  echo -n "Enter file name to import tasks from: "
  read import_file
  if [ -f "$import_file" ]; then
    cat "$import_file" >> "$TODO_FILE"
    echo -e "${GREEN}Tasks imported from $import_file.${NC}"
  else
    echo -e "${RED}File not found!${NC}"
  fi
}

# Main loop
while true; do
  show_menu
  read -n 1 -s choice
  echo
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
    'e') export_tasks ;;
    'i') import_tasks ;;
    'x') echo -e "${GREEN}Goodbye!${NC}"; exit ;;
    *) echo -e "${RED}Invalid option! Please try again.${NC}" ;;
  esac
done
