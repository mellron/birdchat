**To:** ficcintegration@dtcc.com
**Subject:** GSD Interactive Messaging — Connectivity and Message Format Confirmation for Repo Trade Submission

Hi,

My name is Doug Tolley and I am with U.S. Bank (USB). We are in the process of automating our Treasury trade submission to the Fixed Income Clearing Corporation (FICC) Government Securities Division (GSD) to comply with the Treasury Clearing Rule deadline of December 31, 2026.

We have reviewed the GSD Interactive Messaging (IM) Member Specifications for Comparison Input & Output (GSD200, Version 4.1, March 2023) and have a few questions to help us confirm our approach:

1. **Message formats** — Based on our review of GSD200, we believe we need to use the **MT515 DVP style** for Delivery vs. Payment (DVP) repo transactions and the **MT515 GCF style** for General Collateral Finance (GCF) repo transactions. Can you confirm this is correct for our use case? Additionally, are there other message types we should anticipate for the full trade lifecycle — for example, trade status responses, confirmations, or settlement messages?

2. **MQ connectivity** — We understand FICC uses its own proprietary MQ network. Can you provide details on how to establish connectivity, including queue names and any onboarding steps required?

3. **Testing and certification** — What is the process for testing and certifying our integration before going live?

We are happy to provide additional details about our transaction types or infrastructure if helpful.

Thank you,
Doug Tolley
U.S. Bank
