# Product Information LWC & REST API

## Overview
This repository contains the Salesforce implementation for **product information** retrieval based on a customer's product and home country. It includes:

- A **Lightning Web Component (LWC)** for Case layouts.
- A **REST API** for external systems to retrieve product pricing by UUID(s).
- A **bulk UUID mechanism** to prevent hitting Salesforce daily API limits.

---

## Features

### LWC
- Displayed on **Case layouts**.
- Shows product information based on the **contact's product and home country**.
- If **no contact** is associated with the Case, the component will **not appear**.
- If the contact has **no product assigned**, displays a message prompting the user to select a product.
- Displays:
  - Calendar month cost
  - ATM fee percentage
  - Card replacement cost
- Designed for **easy addition of new products and home country currencies** without code changes.
<img width="1887" height="702" alt="image" src="https://github.com/user-attachments/assets/ff117929-625b-4569-956c-c20d1873b0eb" />

### REST API
- Accepts **UUIDs** from external systems to fetch product information.
- Supports **single UUID** retrieval and **bulk UUID** retrieval.
- Groups results by **product + home country**.
- Each group contains:
  - Product details
  - Home country
  - List of UUIDs
  - Pricing information
- Bulk retrieval reduces the number of API calls, helping avoid **Salesforce daily API limits**.
<img width="1266" height="872" alt="image" src="https://github.com/user-attachments/assets/425a646e-d25a-487a-9220-b8c9c16a0a1f" />

---

## Object & Field Design

| Object             | Field                 | Type                           | Description                                  |
|-------------------|----------------------|--------------------------------|---------------------------------------------|
| Contact           | External_UUID__c      | Text(50), External ID          | External system identifier                  |
| Contact           | Home_Country__c       | Picklist (DE, UK)              | Customer's home country                     |
| Contact           | Product__c            | Lookup(Product)                | Associated product                           |
| ProductPricing__c | ATMFee__c             | Percent                         | ATM fee percentage                           |
| ProductPricing__c | CalendarMonth__c      | Currency                        | Monthly cost                                 |
| ProductPricing__c | CardReplacement__c    | Currency                        | Replacement cost                             |
| ProductPricing__c | Currency_Symbol__c    | Fo_


### REST API Endpoint

### UUID-based Retrieval (Single or Bulk)
POST /services/apexrest/ProductDetailBulk
Content-Type: application/json
Body:
{
"uuids": ["uuid1","uuid2","uuid3"]
}
# Product Information LWC & REST API

## Apex Classes & LWC Components

### Apex Classes

| Name | Type | Purpose / Scenario | Inputs / Outputs / Notes |
|------|------|------------------|-------------------------|
| **ContactSelector** | Apex Class | Fetches `Contact` records based on specific criteria, e.g., `External_UUID__c` for external API requests. | **Input:** UUID(s) <br> **Output:** List of `Contact` records <br> Used by REST API for both single and bulk UUID requests. |
| **CustomerProductInfoController** | Apex Class (Controller) | Server-side controller for the LWC `CustomerProductInfo`. Retrieves product pricing information based on **contact’s product and home country**. | **Input:** Contact ID (from Case context) <br> **Output:** Product pricing info (`CalendarMonth__c`, `ATMFee__c`, `CardReplacement__c`) <br> Handles scenario when no contact or no product assigned. |
| **PricingInfo Wrapper** | Apex Class (Wrapper / DTO) | Encapsulates product pricing details in a structured format for LWC and REST API responses. | Fields: `calendarMonth`, `atmFee`, `cardReplacement`, `currencySymbol` <br> Used in **both LWC display** and **REST API responses**. |
| **ProductDetailRest** | Apex Class (REST API) | Handles **single and bulk UUID** requests for external systems. Returns product pricing for a given contact based on `External_UUID__c`. | **Input:** UUID(s) <br> **Output:** Pricing info in JSON <br> Supports single and bulk contact retrieval scenarios. |
| **ProductPricingSelector** | Apex Class (Selector) | Handles **SOQL queries** for `ProductPricing__c` based on product and home country. | **Input:** Product ID and home country (single or bulk) <br> **Output:** List of `ProductPricing__c` records <br> Supports both single and bulk pricing queries. |
| **ProductPricingService** | Apex Class (Service Layer) | Business logic for fetching **product pricing** and converting to `PricingInfo` wrappers. Supports both **single** and **bulk UUID** scenarios. | **Input:** Contact(s) or product + country <br> **Output:** List of `PricingInfo` <br> Handles aggregation for bulk REST API. |
| **TestDataFactory** | Apex Class | Generates test data for Apex unit tests. Creates Contacts, Products, and ProductPricing records. | **Used in:** All unit tests <br> Simplifies test coverage for LWC, REST API, and service methods. |

---

### Lightning Web Components (LWC)

| Name | Type | Purpose / Scenario | Notes |
|------|------|------------------|------|
| **CustomerProductInfo** | Lightning Web Component | Displays **product pricing information** on a Case layout. Retrieves data from `CustomerProductInfoController`. | Handles scenario where: <br> - Case has a contact → shows product info <br> - Case has no contact → LWC hidden <br> - Contact has no product → displays message prompting selection. |
| **Illustration** | Lightning Web Component | Handles **errors and warnings** in the UI. Shows messages when required fields are missing or **no pricing found**. | Typically used in conjunction with `CustomerProductInfo` to display user-friendly feedback. |

---
