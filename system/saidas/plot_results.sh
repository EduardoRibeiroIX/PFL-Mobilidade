#!/bin/bash

# Read the Averaged Train Loss, Averaged Test Accuracy, and Averaged Test AUC values from the EntropySelection.txt file and save them to separate arrays
train_loss_entropy=($(grep -o 'Averaged Train Loss: [0-9]*\.[0-9]*' EntropySelection.txt | grep -o '[0-9]*\.[0-9]*'))
test_accuracy_entropy=($(grep -o 'Averaged Test Accuracy: [0-9]*\.[0-9]*' EntropySelection.txt | grep -o '[0-9]*\.[0-9]*'))
auc_score_entropy=($(grep -o 'Averaged Test AUC: [0-9]*\.[0-9]*' EntropySelection.txt | grep -o '[0-9]*\.[0-9]*'))

train_loss_entropy_dropout=($(grep -o 'Averaged Train Loss: [0-9]*\.[0-9]*' EntropySelectionDropout.txt | grep -o '[0-9]*\.[0-9]*'))
test_accuracy_entropy_dropout=($(grep -o 'Averaged Test Accuracy: [0-9]*\.[0-9]*' EntropySelectionDropout.txt | grep -o '[0-9]*\.[0-9]*'))
auc_score_entropy_dropout=($(grep -o 'Averaged Test AUC: [0-9]*\.[0-9]*' EntropySelectionDropout.txt | grep -o '[0-9]*\.[0-9]*'))

# Read the Averaged Train Loss, Averaged Test Accuracy, and Averaged Test AUC values from the NormalSelection.txt file and save them to separate arrays
train_loss_normal=($(grep -o 'Averaged Train Loss: [0-9]*\.[0-9]*' NormalSelection.txt | grep -o '[0-9]*\.[0-9]*'))
test_accuracy_normal=($(grep -o 'Averaged Test Accuracy: [0-9]*\.[0-9]*' NormalSelection.txt | grep -o '[0-9]*\.[0-9]*'))
auc_score_normal=($(grep -o 'Averaged Test AUC: [0-9]*\.[0-9]*' NormalSelection.txt | grep -o '[0-9]*\.[0-9]*'))

train_loss_normal_dropout=($(grep -o 'Averaged Train Loss: [0-9]*\.[0-9]*' NormalSelectionDropout.txt | grep -o '[0-9]*\.[0-9]*'))
test_accuracy_normal_dropout=($(grep -o 'Averaged Test Accuracy: [0-9]*\.[0-9]*' NormalSelectionDropout.txt | grep -o '[0-9]*\.[0-9]*'))
auc_score_normal_dropout=($(grep -o 'Averaged Test AUC: [0-9]*\.[0-9]*' NormalSelectionDropout.txt | grep -o '[0-9]*\.[0-9]*'))

# Print the arrays to the console
echo "Entropy Selection Averaged Train Loss: ${train_loss_entropy[@]}"
echo "Entropy Selection Averaged Test Accuracy: ${test_accuracy_entropy[@]}"
echo "Entropy Selection Averaged Test AUC: ${auc_score_entropy[@]}"
echo "Normal Selection Averaged Train Loss: ${train_loss_normal[@]}"
echo "Normal Selection Averaged Test Accuracy: ${test_accuracy_normal[@]}"
echo "Normal Selection Averaged Test AUC: ${auc_score_normal[@]}"
echo "Entropy Selection Dropout Averaged Train Loss: ${train_loss_entropy_dropout[@]}"
echo "Entropy Selection Dropout Averaged Test Accuracy: ${test_accuracy_entropy_dropout[@]}"
echo "Entropy Selection Dropout Averaged Test AUC: ${auc_score_entropy_dropout[@]}"
echo "Normal Selection Dropout Averaged Train Loss: ${train_loss_normal_dropout[@]}"
echo "Normal Selection Dropout Averaged Test Accuracy: ${test_accuracy_normal_dropout[@]}"
echo "Normal Selection Dropout Averaged Test AUC: ${auc_score_normal_dropout[@]}"

# Save the arrays to separate files
echo "${train_loss_entropy[@]}" > train_loss_entropy.txt
echo "${test_accuracy_entropy[@]}" > test_accuracy_entropy.txt
echo "${auc_score_entropy[@]}" > auc_score_entropy.txt
echo "${train_loss_normal[@]}" > train_loss_normal.txt
echo "${test_accuracy_normal[@]}" > test_accuracy_normal.txt
echo "${auc_score_normal[@]}" > auc_score_normal.txt
echo "${train_loss_entropy_dropout[@]}" > train_loss_entropy_dropout.txt
echo "${test_accuracy_entropy_dropout[@]}" > test_accuracy_entropy_dropout.txt
echo "${auc_score_entropy_dropout[@]}" > auc_score_entropy_dropout.txt
echo "${train_loss_normal_dropout[@]}" > train_loss_normal_dropout.txt
echo "${test_accuracy_normal_dropout[@]}" > test_accuracy_normal_dropout.txt
echo "${auc_score_normal_dropout[@]}" > auc_score_normal_dropout.txt

# Use Python's Matplotlib library to plot the values side by side
python - << END
import matplotlib.pyplot as plt

# Load the values from the files
with open('train_loss_entropy.txt') as f:
    train_loss_entropy = [float(x) for x in f.readline().split()]

with open('test_accuracy_entropy.txt') as f:
    test_accuracy_entropy = [float(x) for x in f.readline().split()]

with open('auc_score_entropy.txt') as f:
    auc_score_entropy = [float(x) for x in f.readline().split()]

with open('train_loss_normal.txt') as f:
    train_loss_normal = [float(x) for x in f.readline().split()]

with open('test_accuracy_normal.txt') as f:
    test_accuracy_normal = [float(x) for x in f.readline().split()]

with open('auc_score_normal.txt') as f:
    auc_score_normal = [float(x) for x in f.readline().split()]

with open('train_loss_entropy_dropout.txt') as f:
    train_loss_entropy_dropout = [float(x) for x in f.readline().split()]

with open('test_accuracy_entropy_dropout.txt') as f:
    test_accuracy_entropy_dropout = [float(x) for x in f.readline().split()]

with open('auc_score_entropy_dropout.txt') as f:
    auc_score_entropy_dropout = [float(x) for x in f.readline().split()]

with open('train_loss_normal_dropout.txt') as f:
    train_loss_normal_dropout = [float(x) for x in f.readline().split()]

with open('test_accuracy_normal_dropout.txt') as f:
    test_accuracy_normal_dropout = [float(x) for x in f.readline().split()]

with open('auc_score_normal_dropout.txt') as f:
    auc_score_normal_dropout = [float(x) for x in f.readline().split()]


# Create plots and save them to image files
plt.plot(train_loss_entropy, label='Entropy Selection', color='0.5')
plt.plot(train_loss_normal, label='Normal Selection', color='0.8')
plt.xlabel('Rounds', fontsize=14)
plt.ylabel('Train Loss', fontsize=14)
plt.xticks(fontsize=14)
plt.yticks(fontsize=14)
plt.legend()
plt.savefig('train_loss_iid_comparison.png')
plt.clf()

plt.plot(test_accuracy_entropy, label='Entropy Selection', color='0.5')
plt.plot(test_accuracy_normal, label='Random Selection', color='0.8')
plt.xlabel('Rounds', fontsize=14)
plt.ylabel('Accuracy', fontsize=14)
plt.xticks(fontsize=14)
plt.yticks(fontsize=14)
plt.legend()
plt.savefig('test_accuracy_iid_comparison.png')
plt.clf()

plt.plot(auc_score_entropy, label='Entropy Selection', color='0.5')
plt.plot(auc_score_normal, label='Random Selection', color='0.8')
plt.xlabel('Rounds', fontsize=14)
plt.ylabel('AUC Score', fontsize=14)
plt.xticks(fontsize=14)
plt.yticks(fontsize=14)
plt.legend()
plt.savefig('auc_score_iid_comparison.png')
plt.clf()

plt.plot(train_loss_entropy_dropout, label='Entropy Selection', color='0.5')
plt.plot(train_loss_normal_dropout, label='Normal Selection', color='0.8')
plt.xlabel('Rounds', fontsize=14)
plt.ylabel('Train Loss', fontsize=14)
plt.xticks(fontsize=14)
plt.yticks(fontsize=14)
plt.legend()
plt.savefig('train_loss_dropout_iid_comparison.png')
plt.clf()

plt.plot(test_accuracy_entropy_dropout, label='Entropy Selection', color='0.5')
plt.plot(test_accuracy_normal_dropout, label='Random Selection', color='0.8')
plt.xlabel('Rounds', fontsize=14)
plt.ylabel('Accuracy', fontsize=14)
plt.xticks(fontsize=14)
plt.yticks(fontsize=14)
plt.legend()
plt.savefig('test_accuracy_dropout_iid_comparison.png')
plt.clf()

plt.plot(auc_score_entropy_dropout, label='Entropy Selection', color='0.5')
plt.plot(auc_score_normal_dropout, label='Random Selection', color='0.8')
plt.xlabel('Rounds', fontsize=14)
plt.ylabel('AUC Score', fontsize=14)
plt.xticks(fontsize=14)
plt.yticks(fontsize=14)
plt.legend()
plt.savefig('auc_score_dropout_iid_comparison.png')
plt.clf()
END