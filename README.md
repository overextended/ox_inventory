<h2 align='center'><a href='https://thelindat.github.io/linden_inventory/'>Click here to view the install guide and documentation</a></h2>
<p align='center'><a href='https://streamable.com/bggvpg'>Showcase</a> | <a href='https://discord.gg/hmcmv3P7YW'>Discord</a> | <a href='https://thelindat.github.io/linden_inventory/media'>Media</a></p>


<h3 align='center'> This resource is undergoing a complete rewrite - there will be no more patches<br>
I strongly advice waiting for the update before setting up this inventory</h3>


<br><br><br>


## What's changed?
##### This information concerns the initial release of linden_inventory
Despite all the changes I've implemented to hsn-inventory, there's a lot that I hadn't changed since I didn't want to break things I wasn't familiar with. There was a lot of functions or events performing the same (or very similar) tasks, sometimes only being used once if at all; my biggest issue though was with the inventory data saving. I've moved the project so that a still incomplete but mostly working version of hsn-inventory can remain as it is, but without any future support by myself.

* Cleaned up or optimised many functions and events
* Changed data formatting when sending information between client and server (a lot of data was sent twice or fragmented)
* Moved config around to make things a little more accessable, moved some tables into config where appropriate
* Global inventory tables for shops to load from, instead of entering the data for each
* Support for randomising prices at each shop at resource startup (disabled)
* Removed defined variables that weren't being called
* Inventories are now stored in a single table to make referencing data a lot less of a hassle
* Inventory data saving is more agnostic (don't need separate statements for each inventory type)
* Cleaner transition from regular inventory to a drop and vice versa
* Drops should be created and removed properly, and existing drops are loaded to client at login
* Improved performance
* Support for setting a players max weight
* New exports for use with xPlayer functions, to remove the need for modifying the framework in the future
* Full syncing of accounts data with inventory
* Better error catching and a method of preventing the resource from setting/saving data when it isn't loaded correctly
* Mark when an inventory is changed and only query the database if items have moved
* Better tracking of an inventory's state (if it's open)
* And more... (it's hard to remember every change made over 48 hours)

<br><br><br><h3 align='center'>Legal Notices</h2>
<table><tr><td>
Linden Inventory for ESX Legacy  

Copyright (C) 2021  Linden, Hasan  


This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.  


This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.  


You should have received a copy of the GNU General Public License
along with this program.  
If not, see <https://www.gnu.org/licenses/>
</td></tr>
<tr><td>
This resource is a derivative of <a href='https://github.com/hsnnnnn/hsn-inventory/tree/9feef47269dbf8271f9e6b477188da88c15758e3'>hsn-inventory</a>, released February 2021.
</td></td></table>
