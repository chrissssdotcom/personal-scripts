# Shotgun Quick-info Puller
- It pulls information out of a database called Shotgun (now Flow Production Tracking/ShotGrid), and displays it in an easy to read format in the terminal.

## Example Output
```
sh-5.2$ python3 python/shotgun/infopuller/findWsLocation.py aberdeen
+---------------+----------------------+
| Field         | Value                |
+===============+======================+
| Name          | aberdeen             |
+---------------+----------------------+
| Serial Number | 12345                |
+---------------+----------------------+
| Used By       | John Pork            |
+---------------+----------------------+

+------------+---------------------+
| Field      | Value               |
+============+=====================+
| Location 1 | ADL                 |
+------------+---------------------+
| Location 2 | FROME ST            |
+------------+---------------------+
| Location 3 | BURGER_DESK         |
+------------+---------------------+
```
