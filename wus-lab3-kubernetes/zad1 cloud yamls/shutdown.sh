#!/bin/bash

kubectl delete -f ./krok_5_deploymenty
kubectl delete -f ./krok_4_baza_danych
kubectl delete -f ./krok_3_serwisy_i_konf
kubectl delete -f ./krok_2_pers_volume
kubectl delete -f ./krok_1_namespace



