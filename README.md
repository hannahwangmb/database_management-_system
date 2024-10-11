
## Introduction

Background and Problem Statement

The environmental-activist organization named G has grown to a point where some computerized record keeping would help with day-to-day operations. They would use online services for such record keeping, but are worried about security and surveillance given constant revelations on how some state-sponsored security services gather data on ordinary citizens via data transmitted over the Internet.  They would rather build a home-grown system to help them with their work.

The main purpose for which the group exists is to raise public awareness on emerging environmental issues that have relatively local impact (i.e., “local” here would mean a region up to a size of, say,  “Vancouver Island”). Although G keeps in touch with other, more globally-oriented environmental groups, and some G members belong to such groups, G’s focus is on “as-local-as-possible” issues.

Attempts to raise public awareness and effect change are via “campaigns”.  These are person-on-the-street activities where volunteers are scheduled to be at street corners and public squares in towns or cities.  There the volunteers use posters, placards, and other material to capture the attention of citizens in the public space and share with them the issues central to the campaign. These campaigns can last anywhere from two weeks to two months, and may have events taking place simultaneously in the same, or different, cities and towns and villages. There is a little bit of fundraising that also occurs during campaigns, but G is mostly funded by several large donors. Campaigns do have some costs associated with them. At present G operates out of a small downtown office, the rent of which is paid by some G supporters.

G also has a website. Although the computer system solving the problem described here will not be linked to the website, the group believes it makes sense that something be done to keep track of when and how campaigns (and the phases of each campaign) will be pushed out ¬– and have been pushed out – to the website.

There are a few salaried employees (on very low salaries!) and most of the organization is based on the work of its volunteers. There are two tiers of volunteers: those who have participated in more than three publicity campaigns and then the others who have participated in two or fewer. There are also members who are not volunteers but who are interested in supporting the activities of Therefore theence the computer system is needed to help G keep track of campaigns, who is working on them, when activities need to happen, and the way funds actually flow in and out.

For this problem you must also use your own understanding of the way such groups work in order to “fill in the gaps” of the description above. The assumptions you make must be rooted in the real world and therefore when stating your assumptions please provide some justification. As you think through the problems in this assignment, feel free to look at how other, similar groups are organized in the munity

In the previous assignment you modelled the database needed for a hypothetical environmental activist organization named G. In this assignment you will use those tables, queries, views, etc. from within a Python program that you will write. This program is intended to be used by employees of G who are going about the tasks of the organization. In order to keep our focus on interacting with the database (i.e., the classical "application-server"-tier level of coding) we will keep the user interface very simple (i.e., text-based prompts). 

## Usage

	$ \i gngdump.sql
	$ python3 gng.py