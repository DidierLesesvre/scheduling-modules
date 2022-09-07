% Run with COIN-BC solver
    
    % PARAMETERS
    
    int: n; % number of students
    set of int: STUDENTS=1..n; % students
    
    int: m; % number of topics
    set of int: PREFERENCE=1..m; % possible preference rankings
    set of int: TOPICS=1..m; % different topics
    set of int: RANK=1..m; % different topics
    set of int: GROUPS=1..m; % different topics
    
    int: c; % number of courses each student will take
    set of int: COURSES=1..c; % courses for each student
    
    int: G; % maximum times a topic can be taught
    int: maxseats; % number of seats available per course max
    int: minseats; % number of seats minimum per course
    
    int: timeslots; % possible time slots for the courses
    set of int: TIMESLOTS=1..timeslots; 
    
    array[STUDENTS,TOPICS] of PREFERENCE: preference; % ranking of topics by each student

    % VARIABLES
    
    array[STUDENTS, TOPICS] of var bool: topicSelected;
    array[TOPICS, TIMESLOTS] of var 0..n: number;

    array[STUDENTS,TOPICS,TIMESLOTS] of var bool: course; % topics and timeslot assigned to each student

    constraint % channel selected topics for each student
       forall(ss in STUDENTS, tt in TOPICS) (
          topicSelected[ss,tt] = exists(ts in TIMESLOTS)(course[ss,tt,ts]));

    constraint % channel number of students within each topic/timeslot
       forall(tt in TOPICS, ts in TIMESLOTS) (
          number[tt,ts] = sum(ss in STUDENTS)(course[ss,tt,ts]));

    constraint % make sure there are enough students in a class but not too many
       forall(tt in TOPICS, ts in TIMESLOTS) (
          number[tt,ts] > 0 -> number[tt,ts] >= minseats /\ number[tt,ts] <= maxseats);

    constraint % each student must have exactly c classes
       forall(ss in STUDENTS) (sum(tt in TOPICS)(topicSelected[ss,tt]) == c);

    constraint % student can only be assigned to a topic once, ie, only 1 timeslot
       forall(ss in STUDENTS, tt in TOPICS)(sum(ts in TIMESLOTS)(course[ss,tt,ts]) <= 1);

    constraint % students can't have classes during the same timeslot
       forall(ss in STUDENTS, ts in TIMESLOTS)(sum(tt in TOPICS)(course[ss,tt,ts]) <= 1);

    constraint % limit maximum number of times a topic can be taught (GROUPS)
       forall(tt in TOPICS)(sum(ts in TIMESLOTS)(number[tt,ts] > 0) <= G);

    var int: satisfaction;
    constraint
       satisfaction = sum(ss in STUDENTS, tt in TOPICS)(topicSelected[ss,tt] * preference[ss,tt]);
    
    solve minimize satisfaction;

    output(["satisfaction: \(satisfaction)\n"]);
    output(["topics\t\ttimeslots\t\tpreferences\n"]);
    output([" ", join(" ", [show([tt | tt in TOPICS where topicSelected[ss,tt]]) ++ "\t" ++
                            show([ts | tt in TOPICS, ts in TIMESLOTS where course[ss,tt,ts]]) ++ "\t" ++
                            show([preference[ss,tt] | tt in TOPICS where topicSelected[ss,tt]]) ++
                            "\n" | ss in STUDENTS])]);
    output(["\ntopic ->  #students in timeslot:\n"]);
    output([" ", join(" ", [show(tt) ++ " -> " ++ show([number[tt,ts] | ts in TIMESLOTS]) ++ "\n" | tt in TOPICS])]);
    output(["\ntopic -> timeslots:\n"]);
    output([" ", join(" ", [show(tt) ++ " -> " ++ show([ts | ts in TIMESLOTS where number[tt,ts] > 0]) ++ "\n" | tt in TOPICS])]);
    output(["Nombre de 7 = " ++ show(sum(ss in STUDENTS, tt in TOPICS where topicSelected[ss,tt] * preference[ss,tt] >= 7)(1))]); 
