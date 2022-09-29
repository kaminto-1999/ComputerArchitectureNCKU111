#include<stdio.h>
#include<stdlib.h>
struct Node
{
    int data;
    struct Node* next;
};
void push(struct Node** head_ref,
          int new_data)
{
    // Allocate node
    struct Node* new_node =
           (struct Node*) malloc(sizeof(struct Node));
 
    // Put in the data
    new_node->data = new_data;
 
    // Link the old list off the new node
    new_node->next = (*head_ref);
 
    // Move the head to point to the new node
    (*head_ref) = new_node;
}
void printList(struct Node *ptr)
{
    while (ptr != NULL)
    {
        printf("%d->", ptr->data);
        ptr = ptr->next;
    }
    printf("NULL \n");
}
struct Node* middleNode(struct Node* head){
    int i = 0;
    struct Node *new = head;
    while (new->next != NULL)
    {
        new = new->next;
        i++;
    }
    i = (i % 2 == 0) ? i / 2 : i / 2 + 1;
    new = head;
    while (i != 0)
    {
        new = new->next;
        i--;
    }
    printf("\n Middle is: %d \n",new->data);
    return new;
}

int main()
{
    // Start with the empty list
    struct Node* head = NULL;
    int i;
 
    for (i = 4; i > 0; i--)
    {
        push(&head, i);
        printList(head);
        middleNode(head);
    }
    return 0;
}