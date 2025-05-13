# The Haslemere Human Mobility and Proximity Dataset

## Summary

This dataset captures high-resolution human mobility and interpersonal proximity patterns collected from 469 volunteers in the town of Haslemere, UK, over three consecutive days (12–14 October 2017). The data were collected via a custom mobile phone application and processed to produce time-resolved pairwise distance measurements between individuals. The dataset was developed in the context of the BBC Four documentary *Contagion! The BBC Four Pandemic*, and it supports research in infectious disease modeling, human mobility, network epidemiology, and dynamic systems.

---

## Contents

- `DataS1.csv`: Main dataset containing pairwise distances within 50 meters between individuals at 5-minute intervals.
- `DataS2.csv`: Mapping of dataset time indices to real-world timestamps (British Summer Time).
- `simulation_code/`: Scripts for simulating disease transmission using the SEI model described in the associated publication.
- `README.md`: Metadata and documentation for this dataset.
- `LICENSE.txt`: Terms of use under the CC BY-NC-ND 4.0 license.

---

## Data Description

### Participants
- 469 individuals residing in Haslemere, UK.
- Participants were aged ≥16, or ≥13 with parental consent.
- Participants represent a convenience sample (~4.2% of the town population).

### Temporal Scope
- Start: 2017-10-12 07:00 BST  
- End: 2017-10-14 22:55 BST  
- Interval: 5 minutes  
- Total time points: 576

### Spatial Scope
- Data restricted to Haslemere (GU27 postcode area).
- Pairwise distances computed using the Haversine formula.
- Only distances ≤50 meters are included.

### Variables

#### `DataS1.csv` columns:
| Column        | Description                                    |
|---------------|------------------------------------------------|
| `time_step`   | Integer time index (0–575)                     |
| `user1_id`    | Anonymized ID of first participant             |
| `user2_id`    | Anonymized ID of second participant            |
| `distance_m`  | Distance between participants (meters, int)    |

#### `DataS2.csv` columns:
| Column        | Description                                    |
|---------------|------------------------------------------------|
| `time_step`   | Integer time index                             |
| `timestamp`   | Corresponding timestamp in BST (YYYY-MM-DD HH:MM:SS) |

---

## Methods Summary

- Data collected using the BBC Pandemic mobile app.
- GPS-derived locations aggregated into 5-minute bins.
- Missing data imputed using the last known location or inferred home location.
- Night-time data (23:00–07:00) excluded for privacy.
- Pairwise distances computed for all user pairs within 50 meters at each time step.
- Data further used in a simulated SEI model to explore disease transmission dynamics.

For full methodology, see the associated publication and Supplementary Information.

---

## Usage Notes

- Not a complete census of Haslemere residents; represents a sample of adult contacts.
- Physical barriers (e.g., walls) are not accounted for in distance measurements.
- Night-time movement is not included.
- Suitable for studies in dynamic networks, mobility, epidemic simulation, and contact structure.
- When reusing the data, please cite the associated Data Descriptor and acknowledge the BBC Pandemic project.

---

## License

This dataset is released under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License (CC BY-NC-ND 4.0).  
See `LICENSE.txt` or [https://creativecommons.org/licenses/by-nc-nd/4.0/](https://creativecommons.org/licenses/by-nc-nd/4.0/)

---

## Citation

Please cite as:

> Kissler SM, Klepac P, Tang M, Conlan AJ, Gog JR. (2025). *The Haslemere Human Mobility and Proximity Dataset*. Nature Scientific Data. DOI: [TBD]

---

## Contact

For questions or issues regarding this dataset, please contact:  
Stephen M. Kissler  
Email: sk792@cam.ac.uk

