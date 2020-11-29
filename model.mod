#Sets
set TASKS;                                                #(V) The set of tasks; indexed by (i or j)
set DEF_STATIONS;                                         #(KD) The set of definite stations
set PROB_STATIONS;                                        #(KP) The set of probable stations
set STATIONS = DEF_STATIONS union PROB_STATIONS;          #(K) The set of all possible stations (Union of DEF_STATIONS and PROB_STATIONS); indexed by (k)
set RELATIONS;                                            #(R) The set of all direct precednece relations
set PREDECESSORS {TASKS};                                 #(P_i) The set of all direct and indirect predecessors for task i
set SUCCESSORS {TASKS};                                   #(F_i) The set of all direct and indirect successors for task i
set FEASIBLE_STATIONS {TASKS};                            #(FS_i) The set of stations to which task i is feasibly assignable
set FEASIBLE_TASKS {STATIONS};                            #(FT_k) The set of tasks that are feasibly assignable to station k

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
param pred_exec_time {TASKS};       #(tP_i) The total execution time for all predecessors of task i
param succ_exec_time {TASKS};       #(tF_i) The total execution time for all successors of task i
param earliest_station {TASKS};     #(E_i) The earliest possible station for task i
param latest_station {TASKS};       #(L_i) The latest possible station for task i
param c;

#Variables
var TaskToStation {TASKS, STATIONS} binary;     #(x_ik) 1 if task i assigned to station k, 0 otherwise
var IdleTime {STATIONS} >= 0;                    #(delta_k) The idle time for station k
var StationUsed {STATIONS} binary;              #(u_k) 1 if any task is assigned to station k, 0 otherwise

#Constraints
subject to One {i in TASKS}:sum{k in FEASIBLE_STATIONS[i]}TaskToStation[i, k]=1; #6 each task can only be given to one station
subject to Two {i in RELATIONS, j in RELATIONS}:sum{k in FEASIBLE_STATIONS[i]}k*TaskToStation[i, k]<=sum{k in FEASIBLE_STATIONS[j]}k*TaskToStation[i, k]; #7
subject to Three {i in TASKS, k in FEASIBLE_STATIONS[i]}:TaskToStation[i, k]=1||0; #10
subject to Four {k in PROB_STATIONS}:StationUsed[k]=1||0; #11
subject to Five :lowest_cycle_time<=c<=highest_cycle_time; #13
subject to Six {k in DEF_STATIONS}:sum{i in FEASIBLE_TASKS[k]}exec_time[i]*TaskToStation[i, k]+IdleTime[k]=c; #15
subject to Seven {k in PROB_STATIONS}:sum{i in FEASIBLE_TASKS[k]}exec_time[i]*TaskToStation[i, k]+IdleTime[k]=c; #16
subject to Eight {k in PROB_STATIONS}:sum{i in FEASIBLE_TASKS[k]}exec_time[i]*TaskToStation[i, k]+IdleTime[k]>=c+highest_cycle_time*(StationUsed[k]-1); #17
subject to Nine {k in PROB_STATIONS}:sum{i in FEASIBLE_TASKS[k]}exec_time[i]*TaskToStation[i, k]+IdleTime[k]<=highest_cycle_time*StationUsed[k]; #18
subject to Ten {k in PROB_STATIONS}:StationUsed[k+1]<=StationUsed[k]; #19
subject to Eleven {k in STATIONS}:IdleTime[k]>=0; #20