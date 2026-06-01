# Grokking Simplicity — Technique Reference

All code examples in JavaScript (as in the book).

---

## 1. Actions, Calculations, Data

The foundational taxonomy. Classify every function before doing anything else.

### Category definitions

| Category | Criterion | Safe? | Naming | Examples |
|---|---|---|---|---|
| **Action** | Depends on *when* or *how many times* called | Risky | `action_*` | `action_sendEmail()`, `action_saveUser()`, `action_log()` |
| **Calculation** | Same input → same output. No side effects | Safe | `calc_*` | `calc_total(cart)`, `calc_discount(price, code)`, `calc_formatName(user)` |
| **Data** | Inert recorded facts. No behavior | Safest | plain nouns | `cart`, `user`, `order`, `config` |

### Why actions are dangerous (3 rules of distributed systems)

1. Messages arrive out of order
2. Each message may arrive 0, 1, or more times
3. If you don't hear back, you don't know what happened

These rules apply to **any** action — not just network calls — because actions depend on timing.

### The preference hierarchy

```
Data → Calculation → Action
```

Push complexity to action boundaries. Keep core logic in calculations + data.

### Typical violation: action pretending to be a calculation

```javascript
// BAD — implicit global dependency makes this an action
var shoppingCart = [];
function getCartTotal() {       // depends on WHEN called (cart may have changed)
  return shoppingCart.reduce(...);
}

// GOOD — calculation with explicit name
function calcCartTotal(cart) {  // same input → same output. Pure.
  return cart.reduce(...);
}
```

### Naming convention

Prefix by category so the type is visible at every call site:

```javascript
// Actions — explicit I/O
function action_sendEmail(to, subject, body) { ... }
function action_log(message) { ... }
function action_saveOrder(db, order) { ... }

// Calculations — pure, explicit inputs
function calc_total(cart) { ... }
function calc_discount(price, code) { ... }
function calc_formatAddress(user) { ... }

// Data — plain objects/arrays
const defaultConfig = { taxRate: 0.1, freeShipping: 100 };
```

This makes code reviews faster: the prefix tells you what contract the function must obey.

**Rule for calculations**: all inputs as arguments. No reading globals, files, env, or DOM.

```javascript
// WRONG — implicit input from global
function calcTax() {
  return total * TAX_RATE;    // TAX_RATE is global
}

// RIGHT — explicit inputs
function calcTax(total, taxRate) {
  return total * taxRate;
}
```

---

## 2. Code Smells → FP Refactorings

### 2.1 Express Implicit Argument

**Smell**: function name encodes what data to operate on.

```javascript
// BEFORE — implicit argument in name
const cart = [];
function addToCart(item) { cart.push(item); }
function removeFromCart(name) {
  for (let i = 0; i < cart.length; i++) {
    if (cart[i].name === name) cart.splice(i, 1);
  }
}

// AFTER — make data explicit; convert to pure calculation
function addItem(cart, item) { return cart.concat([item]); }
function removeItemByName(cart, name) {
  return cart.filter(item => item.name !== name);
}
```

### 2.2 Replace Body with Callback

**Smell**: function mixes calculation + side effect (e.g., logging, DOM update).

```javascript
// BEFORE — mixed concerns
function calcCartTotal(cart) {
  const total = cart.reduce(...);
  updateTotalDOM(total);        // side effect
  return total;
}

// AFTER — extracted
function calcCartTotal(cart) {        // calculation
  return cart.reduce(...);
}
function updateTotal(total) {        // action
  updateTotalDOM(total);
}
```

Also applies to try/catch wrappers:

```javascript
// BEFORE — repeated try/catch
function saveWithLogging(doc) {
  try { saveToDB(doc); }
  catch (e) { logError(e); }
}
function sendWithLogging(msg) {
  try { sendEmail(msg); }
  catch (e) { logError(e); }
}

// AFTER — callback
function withLogging(fn, ...args) {
  try { fn(...args); }
  catch (e) { logError(e); }
}
```

### 2.3 Replace Loop with map/filter/reduce

**Smell**: index-based loop processing a collection.

```javascript
// BEFORE
function bestPrices(items) {
  const result = [];
  for (let i = 0; i < items.length; i++) {
    if (items[i].price > 0) {
      result.push({ name: items[i].name, price: items[i].price });
    }
  }
  return result;
}

// AFTER
function bestPrices(items) {
  return items
    .filter(item => item.price > 0)
    .map(item => ({ name: item.name, price: item.price }));
}
```

### 2.4 Split Read-Write Operation

**Smell**: a function both reads and mutates data.

```javascript
// BEFORE — .shift() returns AND mutates
const first = array.shift();

// AFTER — split
function firstElement(array) { return array[0]; }
function dropFirst(array) { return array.slice(1); }

// Or return both (with copy-on-write)
function shift(array) {
  const copy = array.slice();
  const first = copy.shift();
  return { first, array: copy };
}
```

---

## 3. Immutability Disciplines

### 3.1 Copy-on-Write (your code)

Convert mutating operations into pure reads. Three steps:

1. **Wrap** the operation in a function
2. **Copy** before modifying
3. **Return** the modified copy

```javascript
// Array
function push(array, item) {
  const copy = array.slice();  // copy
  copy.push(item);              // modify copy
  return copy;                  // return new
}

// Object
function setPrice(item, price) {
  return { ...item, price };   // spread creates shallow copy
}

// Nested object — structural sharing
function setItemPrice(cart, name, price) {
  return cart.map(item =>
    item.name === name
      ? { ...item, price }      // only this element is new
      : item                     // others share reference
  );
}
```

### 3.2 Defensive Copying (untrusted code)

Protect your data when calling code you don't control.

- **Copy-on-write**: protect your data FROM external code's mutation
- **Defensive copying**: protect YOUR data from external code

```javascript
// BEFORE — external code may mutate
function processOrder(order, discountFn) {
  discountFn(order); // may mutate order!
  return order;
}

// AFTER — defensive copy
function processOrder(order, discountFn) {
  const copy = deepClone(order);
  discountFn(copy);     // external code mutates copy only
  return copy;
}
```

Shallow copy is usually sufficient. Deep copy when external code has access to nested refs.

### Comparison

| | Copy-on-Write | Defensive Copying |
|---|---|---|
| **Purpose** | Convert writes → reads in your code | Protect data from untrusted code |
| **Direction** | Outgoing (your wrappers) | Incoming (external calls) |
| **Trust** | Your own functions | Third-party / legacy code |

---

## 4. Stratified Design

Organize code into layers by meaning and rate of change.

### Call graph rules

- **Top** = business rules, rapidly changing. Few functions depend on it → easy to change.
- **Bottom** = fundamentals, rarely change. Many functions depend on it → test once, reuse everywhere.

### Layer example (MegaMart)

```
Business rules       freeTieClip(), getsFreeShipping(), calcTax()
     ↓
Cart operations      addItem(), removeItemByName(), setPriceByName()
     ↓
Copy-on-write ops    addElementLast(), removeItems()
     ↓
Language built-ins   .slice(), .concat(), spread
```

### 4 patterns

**Pattern 1: Straightforward Implementation**
The function body should solve the problem at the right level of detail.

```javascript
// BAD — array internals at business level
function freeTieClip(cart) {
  let hasTie = false, hasTieClip = false;
  for (let i = 0; i < cart.length; i++) {
    if (cart[i].name === "tie") hasTie = true;
    if (cart[i].name === "tie clip") hasTieClip = true;
  }
  // ...
}

// GOOD — hides array details behind cart operations
function freeTieClip(cart) {
  if (hasItem(cart, "tie") && !hasItem(cart, "tie clip")) {
    return addItem(cart, makeItem("tie clip", 0));
  }
  return cart;
}
```

**Pattern 2: Abstraction Barrier**
Some layers provide interfaces that hide implementation choices.

```javascript
// Cart abstraction barrier — consumers don't know if cart is array or object
function addItem(cart, item) { /* hides impl */ }
function removeItemByName(cart, name) { /* ... */ }
function calcTotal(cart) { /* ... */ }
```

**Pattern 3: Minimal Interface**
Keep interfaces small. Define everything else in terms of the minimal set.

```javascript
// Minimal cart API: addItem, removeItemByName, makeItem
function addItemToCart(cart, item) { return addItem(cart, item); }   // delegate
function removeTieClips(cart) {
  return cart.filter(item => item.name !== "tie clip");              // built on removeItemByName
}
```

**Pattern 4: Comfortable Layers**
Don't add layers for sport. Invest where they accelerate delivery.

### Detecting layer violations

Ask: "Does this function use concepts from two different levels of abstraction?"

---

## 5. Timeline Diagrams

Visual technique for async bug analysis.

### Two fundamentals

1. Actions on the **same** timeline execute **sequentially**
2. Actions on **different** timelines can execute in **any order**

### Drawing a timeline

```
Timeline A:  [Read cart] → [cost_ajax]
                                      ↓
Timeline B:                [Read cart] → [shipping_ajax] → [update DOM]
```

Race condition: both timelines read cart between writes. Result depends on timing.

### Common bug: double-click race

```
Click 1: [Read cart] → [Write cart] → [cost_ajax] → [shipping_ajax] → [update DOM]
Click 2: [Read cart] → [Write cart] → [cost_ajax] → [shipping_ajax] → [update DOM]
                ↑ reads stale value — Write from Click 1 not yet applied
```

### Fixes

| Technique | How | Use when |
|---|---|---|
| **Local state** | Convert global → local variable | Data doesn't need to persist across ops |
| **Queue** | Serialize access to shared resource | Multiple consumers, one resource |
| **Cut()** | Prevent interleaving of two timelines | Atomic section needed |
| **JustOnce()** | Guarantee action runs only once | User-triggered events (button clicks) |

### Simplified queue pattern

```javascript
function Queue() {
  const items = [];
  let running = false;

  function runNext() {
    if (items.length === 0) { running = false; return; }
    running = true;
    const task = items.shift();
    task(() => runNext());  // callback signals completion
  }

  return {
    add(task) {
      items.push(task);
      if (!running) runNext();
    }
  };
}
```

---

## 6. Functional Iteration (map / filter / reduce)

| Tool | Purpose | Signature |
|---|---|---|
| `map` | Transform every element | `(array, fn) → newArray` |
| `filter` | Keep matching elements | `(array, pred) → newArray` |
| `reduce` | Combine into one value | `(array, init, fn) → value` |

### Chaining

```javascript
function orderSummary(cart) {
  return cart
    .filter(item => item.qty > 0)
    .map(item => ({ name: item.name, total: item.price * item.qty }))
    .sort((a, b) => b.total - a.total);
}
```

### When reduce is clearer than map+filter

```javascript
// map + filter (two passes)
const result = arr.filter(x => x > 0).map(x => x * 2);

// reduce (one pass)
const result = arr.reduce((acc, x) => {
  if (x > 0) acc.push(x * 2);
  return acc;
}, []);
```

Prefer map+filter when readability matters. Use reduce when performance-critical.

---

## 7. Functional Core / Imperative Shell

Architecture pattern from Onion Architecture (Chapter 18).

```
┌──────────────────────┐
│   Imperative shell   │  ← actions: I/O, DB, DOM, networking
│   (side effects)     │
│  ┌────────────────┐  │
│  │ Functional core│  │  ← calculations: pure business logic
│  │ (pure, testable)│  │
│  └────────────────┘  │
└──────────────────────┘
```

```javascript
// Imperative shell — actions (prefixed)
function action_handleCheckout(userId, cartId) {
  const user = action_findUser(userId);
  const cart = action_findCart(cartId);
  const total = calc_total(cart.items);
  const eligible = calc_discountEligibility(user, total);
  const finalTotal = eligible ? calc_applyDiscount(total) : total;
  action_createOrder(user, cart, finalTotal);
}

// Pure functions — calculations (prefixed, easy to test)
function calc_total(items) { ... }
function calc_discountEligibility(user, total) { ... }
function calc_applyDiscount(total) { ... }
```

**Rule**: The shell is thin. All decisions live in the core. The shell only orchestrates I/O.

---

## Quick Reference Cheatsheet

| You see this... | Apply this technique |
|---|---|
| Function without category prefix | → Add `action_` or `calc_` prefix |
| Function that reads global | → Make data an explicit parameter |
| Function that mixes I/O + logic | → Split into action + calculation |
| Array/object mutated in place | → Copy-on-write |
| Calling third-party code | → Defensive copy first |
| Business logic mixed with array ops | → Add abstraction barrier layer |
| Async race condition | → Timeline diagram + queue/Cut() |
| Loop over collection | → map/filter/reduce |
| Repeated try/catch | → Replace Body with Callback |
| Function name encodes data ("addToCart") | → Express Implicit Argument |
| Two layers of abstraction in one function | → Stratify |
