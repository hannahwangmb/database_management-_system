#!/usr/bin/env python3

import psycopg2
import datetime
import re

current_datetime = datetime.datetime.now()
current_date = current_datetime.date()

def queries(cursor):
    # Menu options
    menu = {
        1: ("Last 2 planned campaigns' names (start date)", "SELECT * FROM view1;"),
        2: ("Top 3 donors by the number of donations", "SELECT * FROM view2;"),
        3: ("Campaigns with their total expenses", "SELECT * FROM view3;"),
        4: ("Volunteers who participated in more than 2 campaigns", "SELECT * FROM view4;"),
        5: ("Campaigns with their number of participants", "SELECT * FROM view5;"),
        6: ("Campaigns that are upcoming", "SELECT * FROM view6;"),
        7: ("Participants for each campaign", "SELECT * FROM view7;"),
        8: ("Campaigns that have more than 5 participants", "SELECT * FROM view8;"),
        9: ("Top 3 donors by the total amount donated", "SELECT * FROM view9;"),
        10: ("Top 3 volunteers who participated in the most campaigns", "SELECT * FROM view10;\n")
    }


    while True:
        # Display menu
        print("\nWelcome! Select a query to execute:\n")
        for key, value in menu.items():
            print(f"{key}. {value[0]}")
        print("\nEnter 0 to return to the main menu.\n")
        # Get user input
        choice = int(input("Enter your choice: "))

        # Exit program
        if choice == 0:
            print("\nReturning to the main menu...\n")
            break

        # Execute selected query
        if choice in menu:
            print(f"\nExecuting query: {menu[choice][0]}\n")
            cursor.execute(menu[choice][1])
            # Fetch column names
            colnames = [desc[0] for desc in cursor.description]
            print(colnames)
            print()
            for row in cursor.fetchall():
                print(row)
            print()
        else:
            print("Invalid choice, please enter a number from 0 to 10.")


def setup_campaign(cursor, dbconn):
    # Menu options
    menu = {
        1: ("Add a new campaign"),
        2: ("Add a volunteer to a campaign"),
    }

    while True:
        # Display menu
        print("\nWelcome! Select an option:\n")
        for key, value in menu.items():
            print(f"{key}. {value}")
        print("\nEnter 0 to return to the main menu.")

        # Get user input
        choice = int(input("\nEnter your choice: "))

        # Exit program
        if choice == 0:
            print("\nReturning to the main menu...\n")
            break

        # Add a new campaign
        if choice == 1:
            # Add a new campaign
            print("\nAdding a new campaign...")
            name = input("\nEnter the new campaign name: ")
            date_pattern = r'^\d{4}-\d{2}-\d{2}$'
            while True:
                # Prompt the user for start date
                start_date = input("Enter the start date (YYYY-MM-DD): ")
                # Check if start date is in the correct format
                if re.match(date_pattern, start_date):
                    break
                else:
                    print("\nInvalid date format. Please enter the date in the format YYYY-MM-DD.\n")

            while True:
                # Prompt the user for end date
                end_date = input("Enter the end date (YYYY-MM-DD): ")
                # Check if end date is in the correct format
                if re.match(date_pattern, end_date):
                    # Check if end date is after start date
                    if end_date < start_date:
                        print("\nEnd date cannot be before start date. Please enter a valid end date.\n")
                    else:
                        break
                else:
                    print("\nInvalid date format. Please enter the date in the format YYYY-MM-DD.\n")

            # Prompt the user for location
            location = input("Enter the location: ")

            # Prompt the user for description
            description = input("Enter the description (if needed): ")


            # Insert new campaign
            try:
                if len(description) > 0:
                    cursor.execute("INSERT INTO Campaigns (campaignname, startdate, enddate, location, description) VALUES ('%s', '%s', '%s', '%s', '%s') RETURNING campaignid;" % (name, start_date, end_date, location, description))
                else:
                    cursor.execute("INSERT INTO Campaigns (campaignname, startdate, enddate, location) VALUES ('%s', '%s', '%s', '%s') RETURNING campaignid;" % (name, start_date, end_date, location))

                dbconn.commit()
                new_campaign_id = cursor.fetchone()[0]
                print("\nNew campaign %s added successfully! ID: %s \n" % (name, new_campaign_id))
            except psycopg2.Error as e:
                print(e)
                dbconn.rollback()
        
        # Add a volunteer to a campaign
        elif choice == 2:
            # menu: 1. Existing volunteer 2. New volunteer
            print("\nSelect an option:\n")
            print("1. Existing volunteer")
            print("2. New volunteer")
            print("\nEnter 0 to return.\n")

            choice = int(input("Enter your choice: "))
            if choice == 0:
                print("\nReturning...\n")
                break
            
            # Add an existing volunteer to a campaign
            elif choice == 1:
                print("\nAdding an existing volunteer to a campaign...\n")
                while True:
                    campaign_id = input("Enter the Campaign ID: ")
                    # Check if the campaign exists
                    cursor.execute("SELECT campaignname, enddate FROM Campaigns WHERE campaignid = %s", (campaign_id,))
                    campaign_row = cursor.fetchone()
                    if not campaign_row:
                        print("\nCampaign ID %s does not exist. Please enter a valid Campaign ID.\n" % campaign_id)
                    else:
                        # check if the campaign is still ongoing
                        if campaign_row[1] < current_date:
                            print("\nCampaign %s has already ended. Please select another campaign.\n" % campaign_row[0])
                        else:
                            print("\nThank you for joining Campaign (ID:%s) %s!\n" % (campaign_id, campaign_row[0]))
                            break
                while True:
                    participant_id = input("Enter the Participant ID: ")
                    # Check if the participant exists
                    cursor.execute("SELECT name, phone FROM Participants WHERE participantid = %s", (participant_id,))
                    participant_row = cursor.fetchone()
                    if not participant_row:
                        print("\nParticipant ID %s does not exist. Please enter a valid Participant ID.\n" % participant_id)
                    else:
                        print("\nWelcome back, %s! Your Contact Number is %s.\n" % (participant_row[0], participant_row[1]))
                        break
                while True:
                    role = input("Enter the Role ('organizer' or 'participant'): ")
                    if role != 'organizer' and role != 'participant':
                        print("\nInvalid role. Please enter 'organizer' or 'participant'.\n")
                    else:
                        break
                # Insert existing volunteer
                try:
                    cursor.execute("INSERT INTO Campaign_Participants (campaignid, participantid, role) VALUES (%s, %s, %s);",
                        (campaign_id, participant_id, role))
                    dbconn.commit()
                    print("\n %s added to campaign %s successfully.\n Thank you for joining!\n" % (participant_row[0], campaign_id))
                except psycopg2.Error as e:
                    print(e)
                    dbconn.rollback()

            # Add a new volunteer to a campaign
            elif choice == 2:
                print("\nAdding a new participant to a campaign...\n")
                name = input("Enter the Name: ")
                # Prompt the user for tier until a valid input is received
                while True:
                    tier = input("Enter the Tier ('0' for paid employee, '2' for volunteer, '3' for other): ")
                    if tier in ('0', '2', '3'):
                        break  # Exit the loop if the input is valid
                    else:
                        print("\nInvalid tier. Please enter '0', '2', or '3'.\n")
                while True:
                    phone_pattern = r'^\+\d{1,3}\(\d{3}\)\d{3}-\d{4}$'
                    phone = input("Enter the Phone Number(+1(234)567-8910): ")
                    if re.match(phone_pattern, phone):
                        break
                    else:
                        print("Invalid phone number format. Please enter in the format: +1(234)567-8910")
                while True:
                    email = input("Enter the Email: ")
                    # Check if the email is in the correct format
                    if not re.match(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$', email):
                        print("\nInvalid email format. Please enter a valid email.\n")
                    else:
                        break
                # Insert new volunteer
                try:
                    cursor.execute("INSERT INTO Participants (name, tier, email, phone) VALUES (%s, %s, %s, %s) RETURNING participantid;",
                        (name, tier, email, phone))
                    dbconn.commit()
                    new_participant_id = cursor.fetchone()[0]
                    print("\nNew volunteer %s added successfully! Your ID is: '%s', Please make sure to remember your ID.\n" % (name, new_participant_id))
                except psycopg2.Error as e:
                    print(e)
                    dbconn.rollback()

                while True:
                    campaign_id = input("Enter the Campaign ID: ")
                    # Check if the campaign exists
                    cursor.execute("SELECT campaignname, enddate FROM Campaigns WHERE campaignid = %s", (campaign_id,))
                    campaign_row = cursor.fetchone()
                    if not campaign_row:
                        print("\nCampaign ID %s does not exist. Please enter a valid Campaign ID.\n" % campaign_id)
                    else:
                        # check if the campaign is still ongoing
                        if campaign_row[1] < current_date:
                            print("\nCampaign %s has already ended. Please select another campaign.\n" % campaign_row[0])
                        else:
                            try:
                                cursor.execute("INSERT INTO Campaign_Participants (campaignid, participantid, role) VALUES (%s, %s, %s);",
                                    (campaign_id, new_participant_id, 'participant'))
                                dbconn.commit()
                                print("Successfully added %s to Campaign (ID:%s) %s." % (name, campaign_id, campaign_row[0]))
                                print("\nThank you for joining!\n")
                            except psycopg2.Error as e:
                                print(e)
                                dbconn.rollback()
                            break
        else:
            print("Invalid choice, please enter a number from 0 to 2.")

def accounting(cursor):
    # Menu options
    menu = {
        1: ("Total expenses for each campaign"),
        2: ("Total amount donated by each donor"),
        3: ("Recent x months of fund inflows and outflows"),
    }

    while True:
        # Display menu
        print("\nWelcome! Select an option:\n")
        for key, value in menu.items():
            print(f"{key}. {value}")
        print("\nEnter 0 to return to the main menu.")

        # Get user input
        choice = int(input("\nEnter your choice: "))

        # Exit program
        if choice == 0:
            print("\nReturning to the main menu...\n")
            break

        # Total expenses for each campaign
        if choice == 1:
            print("\nTotal expenses for each campaign...\n")
            cursor.execute("SELECT c.campaignid, c.campaignname, ABS(SUM(f.amount)) FROM Fundflow f JOIN Campaigns c ON f.campaignid = c.campaignid WHERE f.type='expense' GROUP BY c.campaignid, c.campaignname ORDER BY c.campaignid;")
            colnames = ['CampaignID', 'CampaignName', 'Total Expense']
            print(colnames)
            print()
            expense_data = cursor.fetchall()
            for row in expense_data:
                print(row)
            print()
            max_value = max([row[2] for row in expense_data])
            for row in expense_data:
                bar_length = int(row[2] / max_value * 40)
                print(f"{row[1]}:\n {'|' * bar_length} {row[2]}")
            print()


        # Total amount donated by each donor
        elif choice == 2:
            print("\nTotal amount donated by each donor...\n")
            cursor.execute("SELECT d.donorid, d.name, SUM(f.amount) AS total_donation_amount FROM Donors d LEFT JOIN Fundflow f ON d.donorid = f.donorid WHERE f.type = 'donation' GROUP BY d.donorid, d.name ORDER BY d.donorid;")
            colnames = ['Donor ID', 'Donor Name', 'Total Donation Amount']
            print(colnames)
            print()
            donation_data = cursor.fetchall()
            for row in donation_data:
                print(row)
            print()
            max_value = max([row[2] for row in donation_data])
            for row in donation_data:
                bar_length = int(row[2] / max_value * 400)
                print(f"{row[1]}:\n {'|' * bar_length} {row[2]}")

        # Recent x months of fund inflows and outflows
        elif choice == 3:
            print("\nRecent x months of fund inflows and outflows...\n")
            while True:
                months = input("Enter the number of months: ")
                if months.isdigit():
                    break
                else:
                    print("\nInvalid input. Please enter a valid number.\n")
            cursor.execute("SELECT * FROM Fundflow WHERE transactiondate >= CURRENT_DATE - INTERVAL %s month;", (months,))
            colnames = [desc[0] for desc in cursor.description]
            print(colnames)
            print()
            fundflow_data = cursor.fetchall()
            for row in fundflow_data:
                print(row)
            print()
            # Filter out non-numeric values and convert to integer
            numeric_amounts = [row[4] for row in fundflow_data]

            # Check if there are any numeric amounts
            if numeric_amounts:
                max_value = max(numeric_amounts)
                for row in fundflow_data:
                    bar_length = int(int(row[4]) / max_value * 400)
                    print(f"{row[0]}:\n {'|' * bar_length} {row[4]}")
            else:
                print("No numeric values found in the 'amount' column.")


        else:
            print("Invalid choice, please enter a number from 0 to 3.")
        
# 1. List all the campaigns that a participant has participated in.
# 2. allow to add annotation to a participant's record
# 3. allow to add annotation to a campaign's record
def membership_history(cursor, dbconn):
    # Menu options
    menu = {
        1: ("Membership history of a participant"),
        2: ("Add annotation to a participant's record"),
        3: ("Add annotation to a campaign's record"),
    }

    while True:
        # Display menu
        print("\nWelcome! Select an option:\n")
        for key, value in menu.items():
            print(f"{key}. {value}")
        print("\nEnter 0 to return to the main menu.")

        # Get user input
        choice = int(input("\nEnter your choice: "))

        # Exit program
        if choice == 0:
            print("\nReturning to the main menu...\n")
            break

        # List all the campaigns that a participant has participated in
        if choice == 1:
            print("\nList all the campaigns that a participant has participated in...\n")
            while True:
                participant_id = input("Enter the Participant ID to view their membership history: ")
                cursor.execute("SELECT p.name, c.campaignname, c.enddate FROM Participants p JOIN Campaign_Participants cp ON p.participantid = cp.participantid JOIN Campaigns c ON cp.campaignid = c.campaignid WHERE p.participantid = %s;", (participant_id,))
                participant_campaigns = cursor.fetchall()
                if participant_campaigns:
                    print(f"\nParticipant ID {participant_id} has participated in the following campaigns:\n")
                    colnames = ['Campaign Name', 'End Date']
                    print(colnames)
                    for row in participant_campaigns:
                        print(row[1], row[2])
                    break
                else:
                    # Check if the participant exists
                    cursor.execute("SELECT name FROM Participants WHERE participantid = %s;", (participant_id,))
                    participant_name = cursor.fetchone()
                    if participant_name:
                        print(f"\nParticipant ID {participant_id} has not participated in any campaigns.")
                        break
                    else:
                        print(f"\nParticipant ID {participant_id} does not exist. Please enter a valid Participant ID.\n")

        # Add annotation to a participant's record
        elif choice == 2:
            print("\nAdd annotation to a participant's record...\n")
            while True:
                participant_id = input("Enter the Participant ID: ")
                cursor.execute("SELECT name FROM Participants WHERE participantid = %s;", (participant_id,))
                participant_name = cursor.fetchone()
                if participant_name:
                    print(f"\nParticipant ID {participant_id} is {participant_name[0]}.")
                    #print the current annotation
                    cursor.execute("SELECT record FROM Participants WHERE participantid = %s;", (participant_id,))
                    record = cursor.fetchone()
                    print(f"Current annotation: {record[0]}")
                    break
                else:
                    print(f"\nParticipant ID {participant_id} does not exist. Please enter a valid Participant ID.\n")
            annotation = input("Enter the annotation: ")
            try:
                cursor.execute("UPDATE Participants SET record = %s WHERE participantid = %s;", (annotation, participant_id))
                dbconn.commit()
                print("\nAnnotation added successfully!\n")
            except psycopg2.Error as e:
                print(e)
                dbconn.rollback()

        # Add annotation to a campaign's record
        elif choice == 3:
            print("\nAdd annotation to a campaign's record...\n")
            while True:
                campaign_id = input("Enter the Campaign ID: ")
                cursor.execute("SELECT campaignname FROM Campaigns WHERE campaignid = %s;", (campaign_id,))
                campaign_name = cursor.fetchone()
                if campaign_name:
                    print(f"\nCampaign ID {campaign_id} is {campaign_name[0]}.")
                    break
                else:
                    print(f"\nCampaign ID {campaign_id} does not exist. Please enter a valid Campaign ID.\n")
            annotation = input("Enter the annotation: ")
            try:
                cursor.execute("UPDATE Campaigns SET record = %s WHERE campaignid = %s;", (annotation, campaign_id))
                dbconn.commit()
                print("\nAnnotation added successfully!\n")
            except psycopg2.Error as e:
                print(e)
                dbconn.rollback()

        else:
            print("Invalid choice, please enter a number from 0 to 3.")

# 1. List all participants in a campaign
# 2. List all expenses in a campaign
# 3. List start date, end date, location, description and record of a campaign
def campaign_info(cursor):
    user_input = input("\nEnter the Campaign ID: ")
    cursor.execute("SELECT campaignname FROM Campaigns WHERE campaignid = %s", (user_input,))
    campaign_name = cursor.fetchone()
    # if exists, print all infos about the campaign
    if campaign_name:
        cursor.execute("SELECT startdate, enddate, location, description, record FROM Campaigns WHERE campaignid = %s;", (user_input,))
        colnames = ['Start Date', 'End Date', 'Location', 'Description', 'Record']
        print(colnames)
        print()
        campaign_data = cursor.fetchall()
        for row in campaign_data:
            print(row)
        print()

        cursor.execute("SELECT p.name, cp.role FROM Participants p JOIN Campaign_Participants cp ON p.participantid = cp.participantid WHERE cp.campaignid = %s;", (user_input,))
        colnames = ['Participant Name', 'Role']
        print(colnames)
        print()
        participant_data = cursor.fetchall()
        for row in participant_data:
            print(row)
        print()
        
        cursor.execute("SELECT f.amount, f.description FROM Fundflow f WHERE f.campaignid = %s AND f.type = 'expense';", (user_input,))
        colnames = ['Amount', 'Description']
        print(colnames)
        print()
        expense_data = cursor.fetchall()
        for row in expense_data:
            print(row)
        print()
    else:
        print(f"\nCampaign ID {user_input} does not exist. Please enter a valid Campaign ID.\n")

def main():
    dbconn = psycopg2.connect(host='studentdb.csc.uvic.ca', user='c370_s141',
        password='RSaxjuXN')
    cursor = dbconn.cursor()


    while True:
        # basic user menu
        print("\nWelcome! Select an option to start:\n")
        print("1: Prepared Queries")
        print("2: Setting up a campaign")
        print("3: Accounting Information")
        print("4: Membership history")
        print("5: Campaign information")
        print("\nEnter 0 to exit.\n")
        choice = int(input("Enter your choice: "))

        if choice == 0:
            print("\nGoodbye! Exiting program.\n")
            break
        elif choice == 1:
            queries(cursor)
        elif choice == 2:
            setup_campaign(cursor, dbconn)
        elif choice == 3:
            accounting(cursor)
        elif choice == 4:
            membership_history(cursor, dbconn)
        elif choice == 5:
            campaign_info(cursor)
        else:
            print("\nInvalid choice, please enter a number from 0 to 4.")

    dbconn.commit()

    cursor.close()
    dbconn.close()


if __name__ == "__main__": main()
