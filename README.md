<h1 align='center'><a href='https://thelindat.github.io/linden_inventory/'>Installation Guide</a></h1>
<p align='center'><a href='https://streamable.com/bggvpg'>Showcase</a> | <a href='https://discord.gg/hmcmv3P7YW'>Discord</a><br>
  <a href='https://thelindat.github.io/linden_inventory/media'>Media</a></p>

## What's changed?
Despite all the changes I've implemented to hsn-inventory, there's a lot that I hadn't changed since I didn't want to break things I wasn't familiar with. There was a lot of functions or events performing the same (or very similar) tasks, sometimes only being used once if at all; my biggest issue though was with the inventory data saving. I've moved the project so that a still incomplete but mostly working version of hsn-inventory can remain as it is, but without any future support by myself.

* Cleaned up or optimised many functions and events
* Changed data formatting when sending information between client and server (a lot of data was sent twice or fragmented)
* Moved config around to make things a little more accessable, moved some tables into config where appropriate
* Global inventory tables for shops to load from, instead of entering the data for each
* Support for randomising prices at each shop at resource startup (disabled)
* Removed defined variables that weren't being called
* Inventories are now stored in a single table to make referencing data a lot less of a hassle
* Inventory data saving is more agnostic (342 lines down to 151, could still be improved)
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

<br><br><br><h2 align='center'>Disclaimer</h2>
<p align='center'><a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a></p><br>


<p align='center'>Released February 2021 by <a href='https://github.com/hsnnnnn'>Hasan</a> at <a href='https://github.com/hsnnnnn/hsn-inventory/tree/9feef47269dbf8271f9e6b477188da88c15758e3'>hsn-inventory</a>, however the <a href='https://i.imgur.com/IZStQrx.png'>project was cancelled</a>.
