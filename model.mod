#Sets
set TASKS;                                                #(V) The set of tasks; indexed by (i or j)
set DEF_STATIONS;                                         #(KD) The set of definite stations
set PROB_STATIONS;                                        #(KP) The set of probable stations
set PROB_STATIONS_EXCLUDING_FINAL;                        #Set of probable stations, excluding the final probable station (lazy way of getting the set we iterate over in constraint #19)
set STATIONS;                                             #(K) The set of all possible stations (Union of DEF_STATIONS and PROB_STATIONS); indexed by (k)
set RELATIONS;                                            #(R) The set of all direct precednece relations
set PREDECESSORS {TASKS};                                 #(P_i) The set of all direct and indirect predecessors for task i
set SUCCESSORS {TASKS};                                   #(F_i) The set of all direct and indirect successors for task i
set FEASIBLE_STATIONS {TASKS};                            #(FS_i) The set of stations to which task i is feasibly assignable
set FEASIBLE_TASKS {STATIONS};                            #(FT_k) The set of tasks that are feasibly assignable to station k

#Parameters
param num_tasks;                   #(n) The number of tasks
param first_task {RELATIONS};       #The first task in each direct precedece relation
param second_task {RELATIONS};      #The second task in each direct precedence relation
param exec_time {TASKS};           #(t_i) The execution time for task i
param min_exec_time;               #(t_min) The minimum of the execution times over all tasks
param max_exec_time;               #(t_max) The maximum of the execution times over all tasks
param sum_exec_time;               #(t_sum) The sum of the execution times over all tasks
param lowest_cycle_time;           #(c-underlined) The lower bound on the cycle time
param highest_cycle_time;          #(c-bar) The upper bound on the cycle time
param lowest_num_stations;         #(m-underlined) The lower bound on the number of stations
param highest_num_stations;        #(m-bar) The upper bound on the number of stations
param pred_exec_time {TASKS};       #(tP_i) The total execution time for all predecessors of task i
param succ_exec_time {TASKS};       #(tF_i) The total execution time for all successors of task i
param earliest_station {TASKS};     #(E_i) The earliest possible station for task i
param latest_station {TASKS};       #(L_i) The latest possible station for task i

#Variables
var TaskToStation {TASKS, STATIONS} binary;     #(x_ik) 1 if task i assigned to station k, 0 otherwise
var IdleTime {STATIONS} >= 0;                   #(delta_k) The idle time for station k
var StationUsed {PROB_STATIONS} binary;         #(u_k) 1 if any task is assigned to the probable station k, 0 otherwise
var CycleTime >= 0;

#Objective function
minimize Waste : (highest_num_stations - lowest_num_stations + 1) * sum {k in STATIONS} (IdleTime[k]) - sum{k in PROB_STATIONS} StationUsed[k];

#Constraints
subject to Assignment {i in TASKS}: sum{k in FEASIBLE_STATIONS[i]} TaskToStation[i, k] = 1; #6 each task can only be given to one station
subject to Precedence {i in RELATIONS}: sum{k in FEASIBLE_STATIONS[first_task[i]]} k * TaskToStation[first_task[i], k]
                                        <= sum{k in FEASIBLE_STATIONS[second_task[i]]} k * TaskToStation[second_task[i], k];
subject to Cycle: lowest_cycle_time <= CycleTime <= highest_cycle_time; #13 Restrict cycle time variable to between lower and upper bounds on cycle time
subject to TimingA {k in DEF_STATIONS}: sum{i in FEASIBLE_TASKS[k]} (exec_time[i] * TaskToStation[i, k]) + IdleTime[k] = CycleTime; #15 For each definite station, execution time of all assigned tasks + idle time = cycle time
subject to TimingB {k in PROB_STATIONS}: sum{i in FEASIBLE_TASKS[k]} (exec_time[i] * TaskToStation[i, k]) + IdleTime[k] <= CycleTime; #16 For probable stations, execution time for all assigned tasks + idle time <= cycle time
subject to TimingC {k in PROB_STATIONS}: sum{i in FEASIBLE_TASKS[k]} (exec_time[i] * TaskToStation[i, k]) + IdleTime[k] >= CycleTime + highest_cycle_time * (StationUsed[k] - 1); #17 Long explanation; see PPT
subject to TimingD {k in PROB_STATIONS}: sum{i in FEASIBLE_TASKS[k]} (exec_time[i] * TaskToStation[i, k]) + IdleTime[k] <= highest_cycle_time * StationUsed[k]; #18
subject to StationUse {k in PROB_STATIONS_EXCLUDING_FINAL}: StationUsed[k+1] <= StationUsed[k]; #19
