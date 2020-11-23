#Sets
set TASKS;                       #(V) The set of tasks; indexed by (i or j)
set DEF_STATIONS;                #(KD) The set of definite stations
set PROB_STATIONS;               #(KP) The set of probable stations
set STATIONS;                    #(K) The set of all possible stations (Union of DEF_STATIONS and PROB_STATIONS); indexed by (k)
set RELATIONS;                   #(R) The set of all direct precednece relations
set PREDECESSORS {TASKS};        #(P_i) The set of all direct and indirect predecessors for task i
set SUCCESSORS {TASKS};          #(F_i) The set of all direct and indirect successors for task i
set FEASIBLE_STATIONS {TASKS};   #(FS_i) The set of stations to which task i is feasibly assignable
set FEASIBLE_TASKS {STATIONS};   #(FT_k) The set of tasks that are feasibly assignable to station k

#Parameters
param num_tasks;                   #(n) The number of tasks
param exec_time {TASKS};           #(t_i) The execution time for task i
param min_exec_time;               #(t_min) The minimum of the execution times over all tasks
param max_exec_time;               #(t_max) The maximum of the execution times over all tasks
param sum_exec_time;               #(t_sum) The sum of the execution times over all tasks
param lowest_cycle_time;           #(c-underlined) The lower bound on the cycle time
param highest_cycle_time;          #(c-bar) The upper bound on the cycle time
param lowest_num_stations;         #(m-underlined) The lower bound on the number of stations
param highest_num_stations;        #(m-bar) The upper bound on the number of stations
param pred_exec_time {TASK};       #(tP_i) The total execution time for all predecessors of task i
param succ_exec_time {TASK};       #(tF_i) The total execution time for all successors of task i
param earliest_station {TASK};     #(E_i) The earliest possible station for task i
param latest_station {TASK};       #(L_i) The latest possible station for task i

#Variables
var TaskToStation {TASKS, STATIONS} binary;     #(x_ik) 1 if task i assigned to station k, 0 otherwise
var IdleTime {STATION} >= 0;                    #(delta_k) The idle time for station k
var StationUsed {STATIONS} binary;              #(u_k) 1 if any task is assigned to station k, 0 otherwise

#Constraints
