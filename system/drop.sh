# Define an array of -cdr values
cdr_values=(0.16 0.33 0.50)
jr_values=(0.15 0.20 0.25)
# For each -cdr value, run the commands and save the output to separate files
for cdr_value in "${cdr_values[@]}"; do
    for jr_value in "${jr_values[@]}"; do
        # Run the first command and store the output in a log file
        python main.py -data fmnist -m cnn -algo FedAvg -gr 100 -nc 58 -jr "$jr_values" -cdr "$cdr_value" -did 0 2>&1 | tee "command1_$cdr_value\_$jr_value.log"

        # Save the output of the first command to a text file
        cat "command1_$cdr_value\_$jr_value.log" > "NormalSelection_$cdr_value\_$jr_value.txt"
        cat "saida.txt" > "NormalSelection_$cdr_value\_$jr_value\_saida.txt"
        rm "saida.txt"

        # Run the second command and store the output in a log file
        python main.py -data fmnist -m cnn -algo FedAvg -gr 100 -nc 58 -ent True -cdr "$cdr_value" -jr "$jr_values" -did 0 2>&1 | tee "command2_$cdr_value\_$jr_value.log"

        # Save the output of the second command to a text file
        cat "command2_$cdr_value\_$jr_value.log" > "EntropySelection_$cdr_value\_$jr_value.txt"
        cat "saida.txt" > "EntropySelection_$cdr_value\_$jr_value\_saida.txt"
        rm "saida.txt"        

        # Remove the individual log files
        rm "command1_$cdr_value\_$jr_value.log" "command2_$cdr_value\_$jr_value.log"
    done

    python main.py -data fmnist -m cnn -algo FedAvg -gr 100 -nc 58 -ba True -cdr "$cdr_value" -did 0 2>&1 | tee "command3_$cdr_value.log"

    # Save the output of the second command to a text file
    cat "command3_$cdr_value.log" > "BellowAverage_$cdr_value.txt"
    cat "saida.txt" > "BellowAverage_$cdr_value\_saida.txt"
    rm "saida.txt"

    rm "command3_$cdr_value.log"
done