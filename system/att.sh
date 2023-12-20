#!/bin/bash 
#For IID and Non-IID scenarios
# Run the first command and store the output in a log file
python main.py -data fmnist -m cnn -algo FedAvg -gr 100 -nc 60 -jr 0.25 -did 0 2>&1 | tee command1.log

# Save the output of the first command to a text file
cat command1.log > NormalSelection.txt

# Run the second command and store the output in a log file
python main.py -data fmnist -m cnn -algo FedAvg -gr 100 -nc 60 -ent True -did 0 2>&1 | tee command2.log

# Save the output of the second command to a text file
cat command2.log > EntropySelection.txt

# Run the second command and store the output in a log file
python main.py -data fmnist -m cnn -algo FedAvg -gr 100 -nc 60 -ba True -did 0 2>&1 | tee command3.log

# Save the output of the second command to a text file
cat command3.log > BellowAverage.txt

# Remove the individual log files
rm command1.log command2.log command3.log

# Define an array of -cdr values
cdr_values=(0.16 0.33 0.50)

# For each -cdr value, run the commands and save the output to separate files
for cdr_value in "${cdr_values[@]}"; do
    # Run the first command and store the output in a log file
    python main.py -data fmnist -m cnn -algo FedAvg -gr 100 -nc 60 -jr 0.25 -cdr "$cdr_value" -did 0 2>&1 | tee "command1_$cdr_value.log"

    # Save the output of the first command to a text file
    cat "command1_$cdr_value.log" > "NormalSelection_$cdr_value.txt"

    # Run the second command and store the output in a log file
    python main.py -data fmnist -m cnn -algo FedAvg -gr 100 -nc 60 -ent True -cdr "$cdr_value" -did 0 2>&1 | tee "command2_$cdr_value.log"

    # Save the output of the second command to a text file
    cat "command2_$cdr_value.log" > "EntropySelection_$cdr_value.txt"

    python main.py -data fmnist -m cnn -algo FedAvg -gr 100 -nc 60 -ba True -cdr "$cdr_value" -did 0 2>&1 | tee "command3_$cdr_value.log"

    # Save the output of the second command to a text file
    cat "command3_$cdr_value.log" > "BellowAverage_$cdr_value.txt"

    # Remove the individual log files
    rm "command1_$cdr_value.log" "command2_$cdr_value.log" "command3_$cdr_value.log"
done


