internal. 

Prompts: 

Prompt1: 
Elaboration: 
Explain the following stories in terms of internal trafic, external trafic: 

Example 1, taken from Archtecture documentation: 
1. Customer submits a wedding inquiry.
2. The source sends the inquiry to Salesforce or an intake process.
3. Salesforce creates or updates the customer and event record.
4. Mulesoft receives the inquiry and validates the payload.
5. Mulesoft publishes or emits a normalized event downstream.
6. A consumer checks room inventory and venue availability.
7. A quote service computes pricing and package options.
8. Salesforce receives the quote and updates the opportunity.
9. If accepted, booking confirmation is published.
10. Operations teams are notified and the event is scheduled.



(what other concepts can be added? Where do we place this documentation with its answers?)


Explain the following concepts: 
- idempotent consumers. Does this means that this prevents same customers to be twice or more in the system? 
- retries with backoff. 
- dead-letter or failed-message handling. 
- schema validation. 
- downstream systems. 
- "Mulesoft then normalizes the request". 
- "Pub/Sub and Kafka decouple the process". 
- asynchronously. 



Please note that i am still learning and some concepts are new to me. 

Please add the output to the Glosary.md. 









Prompt2: 
Planning and scalability: 
- Please make a roadmap and the planning and all that is necessary to take this project to something that can be offered to differrent clients like different hotels wit the intention to: (examples/options:): 
Sale this repo as a template. 
Work for different hospitality service providers as an employee/freelance/contrator/B2B. 
What other option there are? 
Please list how success can be messure. 
You can print to the /PLANNING/PRODUCT-ROADMAP/product-ROADMAP.md and if necessary generate more .md files




prompt3: 
DATA: 
- Where is the data going to be stored? What will be the type of database/s used for these projects? 

Propmt4: 
What is tenant configuration and tenant data? 
What is DLQ handling?
What is white-label managed platform? 
What options there are in regards to CRMs? Does salesfoce offer a free account or test/try account? What do we need to start using salesforce or what other CRM has free or open source access? 