import time
from flcore.clients.clientavg import clientAVG
from flcore.servers.serverbase import Server
from threading import Thread
import os
import sys


class FedAvg(Server):
    def __init__(self, args, times):
        super().__init__(args, times)

        # select slow clients
        self.set_slow_clients()
        self.set_clients(clientAVG)

        print(f"\nJoin ratio / total clients: {self.join_ratio} / {self.num_clients}")
        print(f"\nCurrent total users: {self.num_clients}")
        print("Finished creating server and clients.")

        # self.load_model()
        self.Budget = []
    
    def select_best_entropy(self):
        dict_clients = {}
        entropies = [0] * len(self.clients)  # initialize entropies with zeros
        for i, client in enumerate(self.clients):
            entropies[i] = client.client_entropy()
            dict_clients[client] = entropies[i]
        #print(entropies)  # print the list of entropies
        #print(dict_clients)
        
        # Sort the dict_clients dictionary by its values (i.e., the entropies) in descending order
        sorted_clients = sorted(dict_clients.items(), key=lambda x: x[1], reverse=True)
    
        # Select the top percentage of the clients with the highest entropies
        num_clients = len(sorted_clients)
        selected_clients = [client for client, entropy in sorted_clients[ : int(num_clients * self.join_ratio)]]
        print(f'Selected Clients: {len(selected_clients)} clients')
        return selected_clients
    

    def treinamento(self, args, i):
        s_t = time.time()

        self.send_models()

        if i%self.eval_gap == 0:
            print(f"\n-------------Round number: {i}-------------")
            print("\nEvaluate global model")
            self.evaluate()

        for client in self.selected_clients:
            client.train()

        # threads = [Thread(target=client.train)
        #            for client in self.selected_clients]
        # [t.start() for t in threads]
        # [t.join() for t in threads]

        self.receive_models()

        if self.dlg_eval and i%self.dlg_gap == 0:
            self.call_dlg(i)
        
        self.aggregate_parameters()

        self.Budget.append(time.time() - s_t)
        
        print('-'*25, 'time cost', '-'*25, self.Budget[-1])


    def train(self, args):
        caminhoAtual = os.getcwd()
        destino = f'{caminhoAtual}/models/fmnist/FedAvg_server.pt'

        for i in range(self.global_rounds+1):

            if args.entropy:
                self.selected_clients = self.select_best_entropy()
                print('Entropy Selection')
            else:
                self.selected_clients = self.select_clients()
                print('Normal Selection')

            if i == 0 and os.path.exists(destino):
                self.load_model()
                for cliente in self.selected_clients:
                    cliente.model = self.global_model

                self.treinamento(args, i)
                if self.auto_break and self.check_done(acc_lss=[self.rs_test_acc], top_cnt=self.top_cnt):
                    break

            else:
                self.treinamento(args, i)
                if self.auto_break and self.check_done(acc_lss=[self.rs_test_acc], top_cnt=self.top_cnt):
                    break


        print("\nBest accuracy.")
        # self.print_(max(self.rs_test_acc), max(
        #     self.rs_train_acc), min(self.rs_train_loss))
        print(max(self.rs_test_acc))
        print("\nAverage time cost per round.")
        print(sum(self.Budget[1:])/len(self.Budget[1:]))

        self.save_results()
        self.save_global_model()

        if self.num_new_clients > 0:
            self.eval_new_clients = True
            self.set_new_clients(clientAVG)
            print(f"\n-------------Fine tuning round-------------")
            print("\nEvaluate new clients")
            self.evaluate()
