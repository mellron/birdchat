## CPMS / Intrader Difference — 5/18/2026

| Field | Value |
|---|---|
| From | Yerigan O'Neil, Corinne M |
| To | Yang, Diana N; Shah, Parshwa |
| Cc | Pytikakis, Manos; Plotkin, Dennis |
| Subject | CPMS/ Intrader Difference 5/18/2026 |
| Date | Tuesday, May 19, 2026 7:00:00 AM |
| Attachments | image001.png, image002.png, image003.png |

---

Hi Diana and Parshwa

In our reconciliation today, there was a difference between CPMS Web and Intrader. The movement happened yesterday and was not picked up on CPMS web version. The cusip is 3133889F9 — ticket number 867004812, held as NMO. The two systems should in sync. NMO securities are excluded from our LCR reporting which means the immediate urgency is lower.

Kind Regards,

Support

---

### image001.png — Reconciliation Summary

| index          | Original Face       | Current Face        | Market Value        |
|----------------|--------------------:|--------------------:|--------------------:|
| CPMS_AFS       |  170,471,069,046.24 |   95,816,227,497.20 |   90,355,526,228.62 |
| CPMS_HTM       |  149,559,857,626.00 |   77,142,588,187.02 |   63,716,337,579.22 |
| CPMS_NMO       |       1,743,334,600.00 |        1,743,334,600.00 |        1,743,334,600.00 |
| CPMS_Total     |  321,774,261,272.24 |  174,702,150,284.22 |  155,815,198,407.84 |
| Intrader_AFS   |  170,471,069,046.24 |   95,816,227,497.19 |   90,355,526,228.47 |
| Intrader_HTM   |  149,559,857,626.00 |   77,142,588,187.02 |   63,716,337,579.26 |
| Intrader_NMO   |       1,727,134,600.00 |        1,727,134,600.00 |        1,727,134,600.00 |
| Intrader_Total |  321,758,061,272.24 |  174,685,950,284.21 |  155,798,998,407.73 |
| **Difference** |       **16,200,000.00** |        **16,200,000.00** |          **16,200,000.11** |

*(Highlighted rows in the original: CPMS_NMO, Intrader_NMO, and the Difference row — all $16,200,000.)*

---

### image002.png — Position Detail (filtered row)

| Security  | Ticket    | Description            | Maturity   | Original Face   | Par/Curr Face   | Fair Value      | Vlookup         | Diff             |
|-----------|-----------|------------------------|------------|----------------:|----------------:|----------------:|----------------:|-----------------:|
| 3133889F9 | 867004812 | FHLB STOCK - SAN FRAN  | 12/31/2050 |   25,650,000.00 |   25,650,000.00 |   25,650,000.00 |   41,850,000.00 |    16,200,000.00 |

---

### image003.png — Intrader Position Detail

```
Active Positions:
----------------
Position:
   Entity Port ID         Ticket          Original Face       Par/Curr Face
   ------ --------       ----------     -----------------   -----------------
   300    100FHSTK       867004812         25,650,000.00       25,650,000.00

Position Location:
   Loc      Original Face         Par/Curr Face
   ---    -----------------     -----------------
   FHL      -16,200,000.00        -16,200,000.00
   HSF       41,850,000.00         41,850,000.00

Position Movement History:
   Enter Dt     Amount Moved     R/D   Loc   Trd Ticket   As of Dt   SettleDt   By
   --------   ----------------   ---   ---   ----------   --------   --------   ---
   05/31/23      300,558,300.00   REC   HSF   867004812   05/26/23   05/26/23   RLA
   05/31/23        4,030,800.00   DEL   HSF   867004813   05/30/23   05/30/23   RLA
   06/05/23       38,677,500.00   DEL   HSF   867004816   06/01/23   06/01/23   RLA
   06/07/23      108,000,000.00   DEL   HSF   867004817   06/05/23   06/05/23   RLA
   06/20/23       94,500,000.00   DEL   HSF   867004819   06/15/23   06/15/23   RLA
   03/25/26       13,500,000.00   DEL   HSF   403098026   03/09/26   03/09/26   JVF
   05/18/26       16,200,000.00   DEL   FHL   867104401   05/15/26   05/15/26   RLA   <-- highlighted
```

---

### Signature

Corinne M Yerigan O'Neil, CFA
Vice President | Finance Director — Collateral Optimization/Derivatives Middle Office
O: 612-303-4152 | M: 612-867-6953 | corinne.oneil@usbank.com

U.S. Bank
U.S. Bank Plaza
200 S 6th St, Minneapolis, MN 55402 | EP-MN-L38F | usbank.com

She/her/hers
