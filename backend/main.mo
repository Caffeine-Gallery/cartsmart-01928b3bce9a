import Bool "mo:base/Bool";
import List "mo:base/List";

import Array "mo:base/Array";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Option "mo:base/Option";
import Text "mo:base/Text";

actor ShoppingList {
  // Define the structure of a shopping list item
  public type Item = {
    id: Nat;
    text: Text;
    completed: Bool;
  };

  // Stable variable to store the shopping list items
  stable var items: [Item] = [];
  stable var nextId: Nat = 0;

  // Add a new item to the shopping list
  public func addItem(text: Text) : async Nat {
    let id = nextId;
    nextId += 1;
    let newItem: Item = {
      id;
      text;
      completed = false;
    };
    items := Array.append(items, [newItem]);
    Debug.print("Added item: " # debug_show(newItem));
    id
  };

  // Get all items in the shopping list
  public query func getItems() : async [Item] {
    items
  };

  // Toggle the completed status of an item
  public func toggleItem(id: Nat) : async Bool {
    let itemIndex = Array.indexOf<Item>({ id; text = ""; completed = false }, items, func(a, b) { a.id == b.id });
    switch (itemIndex) {
      case null {
        Debug.print("Item not found: " # Nat.toText(id));
        false
      };
      case (?index) {
        let item = items[index];
        let updatedItem = {
          id = item.id;
          text = item.text;
          completed = not item.completed;
        };
        items := Array.tabulate<Item>(items.size(), func (i) {
          if (i == index) { updatedItem } else { items[i] }
        });
        Debug.print("Toggled item: " # debug_show(updatedItem));
        true
      };
    }
  };

  // Delete an item from the shopping list
  public func deleteItem(id: Nat) : async Bool {
    let itemIndex = Array.indexOf<Item>({ id; text = ""; completed = false }, items, func(a, b) { a.id == b.id });
    switch (itemIndex) {
      case null {
        Debug.print("Item not found: " # Nat.toText(id));
        false
      };
      case (?index) {
        items := Array.tabulate<Item>(items.size() - 1, func (i) {
          if (i < index) { items[i] } else { items[i + 1] }
        });
        Debug.print("Deleted item with id: " # Nat.toText(id));
        true
      };
    }
  };
}
