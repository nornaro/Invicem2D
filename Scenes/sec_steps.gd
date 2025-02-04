extends Node

"""
Sec 0
0. Timer runs out
1. Send timer call to clients, and let them handle

Sec 1
0. Timer runs out
1. Read Barrack data
2. Generate unit list
3. Send unit lists and timer calls to clients

Sec 3
4. Retrieve turret damage data before next round

Sec 4
5. Upon respawn, spawn units at other filed from server side

Sec 5
A. Approve every transaction server side
B. Calculate and store Barrack, Turret, other building data server side
C. Match calculated data with client
"""
