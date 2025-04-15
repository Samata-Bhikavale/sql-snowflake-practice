select * from Student_Learning;

 -- 1) Identify all the undergraduate students and display their id, gender and course name.
 select student_id,gender,course_name
 from student_learning
 where education_level='Undergraduate';

 --2) Fetch details of female students who spent over 300 mins on videos and have high possibility of dropping out.
 
 select * from student_learning
 where gender='Female' and
 time_spent_on_videos>300
 and dropout_likelihood=True;

 -- 3)Identify students who have either taken Machine Learning or Data Science course and have atleast attempted couple of quiz or have scored over 60 in quiz. Sort data based on least forum participation
 
 select student_id
 from student_learning
 where course_name in ('Machine Learning','Data science')
 and (quiz_attempts>=2 or quiz_scores>60)
 order by forum_participation;

-- 4)How many students prefer learning through visuals
    select count(*)
    from student_learning
    where learning_style = 'Visual';

 
-- 5) What is the minimum and maximum exam score by students with the highest assignment completion rate?

select min(final_exam_score),max(final_exam_score) from student_learning
where assignment_completion_rate= (select max(assignment_completion_rate)from student_learning);

-- 6) What is the average age of all Postgraduate or Undergraduate female students who took Cybersecurity course and either had High engagement level or preferred learning through writing or actively participated in atleast 20 forums. return whole number.
select round(avg(age),0)
from student_learning
where gender='Female'
and education_level in ('Undergraduate','Postgraduate')
and course_name='Cybersecurity'
and 
(engagement_level='High' or learning_style='Reading/Writing' or forum_participation>=20);


7)Idently all the male postgraduate student or female undergraduate student with final score over 90. Output should contains 2 columns, 1 with the student id and second column should indicate male postgraduate student as "Master degree" and female undergraduate student as "Bachelor degree"

select student_id, 
case when gender = 'Male' then 'Master degree' else 'Bachelor degree' end as degree
    from student_learning
    where (gender = 'Male' and education_level = 'Postgraduate' and final_exam_score > 90)
        or (gender = 'Female' and education_level = 'Undergraduate' and final_exam_score > 90)
    order by student_id;
    
 -- 8)What is the average time spent on watching videos based on education level? Consider only those students whose age is a even number. Round the value to a single decimal point.

select round(avg(time_spent_on_videos),1),education_level
from student_learning
where age%2=0
group by education_level;

-- 9)Identify the most popular male and female student among teachers. Popularity is based on students scoring the hight exam score and highest assignment_completion_rate.


with ranked as(select student_id,assignment_completion_rate,final_exam_score,gender,
dense_rank()over(partition by gender order by assignment_completion_rate desc,final_exam_score desc) as rn
from student_learning)
select student_id,assignment_completion_rate,final_exam_score,rn,gender from ranked 
where rn=1 AND gender IN ('Male', 'Female');



 


10) How many male, female and other students have never participated in a forum with bare minimun quiz attempts and have low engagement level. Result should be 3 columns, 1 each for each gender.

select * from student_learning;
select
sum(case when gender='Male' then 1 else 0 end) as male,
sum(case when gender='Female' then 1 else 0 end) as Female,
sum(case when gender='Other' then 1 else 0 end) as other_students
from student_learning
where engagement_level='Low'
and forum_participation=0
and quiz_attempts=(select min(quiz_attempts) from student_learning)
group by gender;

11)Solve the above problem but now display result in 3 seperate rows for each gender
    select gender, count(1)
    from student_learning
    where forum_participation=0
    and engagement_level = 'Low'
    and quiz_attempts in (select min(quiz_attempts) from student_learning)
    group by gender;

12) How many students have taken python, machine learning and data science course?
    select course_name, count(student_id)
    from student_learning
    where course_name in ('Python Basics','Machine Learning','Data Science')
    group by course_name;

-- 13) Identify the courses that are taken by more than 2000 students.
    select course_name,count(1) 
    from student_learning
    group by course_name
    having count(1) > 2000; 


-- 14) What is the preferred course and learning style of students over 40 yrs of age.
  
SELECT c.course_name, l.learning_style
FROM
    (SELECT course_name
     FROM student_learning
     WHERE age > 40
     GROUP BY course_name
     ORDER BY COUNT(*) DESC
     LIMIT 1) c
CROSS JOIN
    (SELECT learning_style
     FROM student_learning
     WHERE age > 40
     GROUP BY learning_style
     ORDER BY COUNT(*) DESC
     LIMIT 1) l;


     
-- 15) Provide a summary of all the courses. How many students have taken each of them but segregate them based on gender.   
    
SELECT course_name
     , SUM(CASE WHEN gender = 'Male' THEN 1 ELSE 0 END) AS male_students
     , SUM(CASE WHEN gender = 'Female' THEN 1 ELSE 0 END) AS female_students
     , SUM(CASE WHEN gender = 'Other' THEN 1 ELSE 0 END) AS other_students
FROM student_learning
WHERE course_name IN ('Python Basics','Machine Learning','Data Science')
GROUP BY course_name
ORDER BY course_name;


-- 16) Identify the most popular courses, between the age group of 15-25, 26-40 and >40. 
-- Course popularity is based on how many students have taken it.
-- Output should be 3 columns specific to each age group.

 SELECT
    (SELECT course_name 
     FROM student_learning 
     WHERE age BETWEEN 15 AND 25 
     GROUP BY course_name 
     ORDER BY COUNT(*) DESC 
     LIMIT 1) AS age_group_15to25,

    (SELECT course_name 
     FROM student_learning 
     WHERE age BETWEEN 26 AND 40 
     GROUP BY course_name 
     ORDER BY COUNT(*) DESC 
     LIMIT 1) AS age_group_26to40,

    (SELECT course_name 
     FROM student_learning 
     WHERE age > 40 
     GROUP BY course_name 
     ORDER BY COUNT(*) DESC 
     LIMIT 1) AS age_group_above_40;
