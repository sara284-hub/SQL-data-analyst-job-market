/*
ทักษะไหนคือทักษะที่ควรเรียนมากที่สุด (คือเป็นที่ต้องการสูงและให้เงินเดือนสูงด้วย)

- หาทักษะที่เป็นที่ต้องการสูงและมีเงินเดือนเฉลี่ยสูงสำหรับตำแหน่ง Data Analyst
- เน้นเฉพาะงานรีโมทที่ระบุเงินเดือน
- ทำไมถึงทำ เพื่อหาทักษะที่ให้ทั้งความมั่นคงในงาน (มีความต้องการสูง) และผลตอบแทนที่ดี (เงินเดือนสูง)

    ช่วยให้วางแผนพัฒนาสายอาชีพด้านการวิเคราะห์ข้อมูลได้อย่างเป็นกลยุทธ์
*/

-- หาทักษะที่เป็นที่ต้องการสูงสำหรับตำแหน่ง Data Analyst
-- ใช้คิวรีที่ 3
WITH skills_demand AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' 
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = True 
    GROUP BY
        skills_dim.skill_id
), 
-- Skills with high average salaries for Data Analyst roles
-- Use Query #4
average_salary AS (
    SELECT 
        skills_job_dim.skill_id,
        ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = True 
    GROUP BY
        skills_job_dim.skill_id
)
-- Return high demand and high salaries for 10 skills 
SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM
    skills_demand
INNER JOIN  average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE  
    demand_count > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;

-- rewriting this same query more concisely
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True 
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;

/*
สรุปทักษะที่คุ้มค่าที่สุดที่ควรเรียนสำหรับ Data Analyst ในปี 2023:

-ภาษาโปรแกรมที่เป็นที่ต้องการสูง: Python และ R โดดเด่นเรื่องความต้องการ โดยมีจำนวนประกาศงาน 236 และ 148 ตามลำดับ แม้ความต้องการจะสูง แต่เงินเดือนเฉลี่ยอยู่ราว $101,397 สำหรับ Python และ $100,499 สำหรับ R แปลว่าทักษะเหล่านี้มีคุณค่ามาก แต่ก็มีคนทำได้เยอะเช่นกัน
-เครื่องมือและเทคโนโลยี Cloud: ทักษะด้านเทคโนโลยีเฉพาะทางอย่าง Snowflake, Azure, AWS และ BigQuery มีความต้องการสูงพร้อมเงินเดือนเฉลี่ยค่อนข้างดี ชี้ให้เห็นว่าแพลตฟอร์มคลาวด์และเทคโนโลยี Big Data สำคัญขึ้นเรื่อยๆ ในงานวิเคราะห์ข้อมูล
-เครื่องมือ Business Intelligence และ Visualization: Tableau และ Looker มีจำนวนประกาศงาน 230 และ 49 ตามลำดับ เงินเดือนเฉลี่ยราว $99,288 และ $103,795 สะท้อนบทบาทสำคัญของการแสดงภาพข้อมูลและ BI ในการสร้างข้อมูลเชิงลึกที่นำไปใช้ได้จริง
-เทคโนโลยีฐานข้อมูล: ความต้องการทักษะฐานข้อมูลทั้งแบบดั้งเดิมและ NoSQL (Oracle, SQL Server, NoSQL) ที่มีเงินเดือนเฉลี่ยอยู่ระหว่าง $97,786 ถึง $104,534 แสดงว่างานจัดเก็บ ดึง และบริหารจัดการข้อมูลยังเป็นที่ต้องการอย่างต่อเนื่อง
[
  {
    "skill_id": 8,
    "skills": "go",
    "demand_count": "27",
    "avg_salary": "115320"
  },
  {
    "skill_id": 234,
    "skills": "confluence",
    "demand_count": "11",
    "avg_salary": "114210"
  },
  {
    "skill_id": 97,
    "skills": "hadoop",
    "demand_count": "22",
    "avg_salary": "113193"
  },
  {
    "skill_id": 80,
    "skills": "snowflake",
    "demand_count": "37",
    "avg_salary": "112948"
  },
  {
    "skill_id": 74,
    "skills": "azure",
    "demand_count": "34",
    "avg_salary": "111225"
  },
  {
    "skill_id": 77,
    "skills": "bigquery",
    "demand_count": "13",
    "avg_salary": "109654"
  },
  {
    "skill_id": 76,
    "skills": "aws",
    "demand_count": "32",
    "avg_salary": "108317"
  },
  {
    "skill_id": 4,
    "skills": "java",
    "demand_count": "17",
    "avg_salary": "106906"
  },
  {
    "skill_id": 194,
    "skills": "ssis",
    "demand_count": "12",
    "avg_salary": "106683"
  },
  {
    "skill_id": 233,
    "skills": "jira",
    "demand_count": "20",
    "avg_salary": "104918"
  },
  {
    "skill_id": 79,
    "skills": "oracle",
    "demand_count": "37",
    "avg_salary": "104534"
  },
  {
    "skill_id": 185,
    "skills": "looker",
    "demand_count": "49",
    "avg_salary": "103795"
  },
  {
    "skill_id": 2,
    "skills": "nosql",
    "demand_count": "13",
    "avg_salary": "101414"
  },
  {
    "skill_id": 1,
    "skills": "python",
    "demand_count": "236",
    "avg_salary": "101397"
  },
  {
    "skill_id": 5,
    "skills": "r",
    "demand_count": "148",
    "avg_salary": "100499"
  },
  {
    "skill_id": 78,
    "skills": "redshift",
    "demand_count": "16",
    "avg_salary": "99936"
  },
  {
    "skill_id": 187,
    "skills": "qlik",
    "demand_count": "13",
    "avg_salary": "99631"
  },
  {
    "skill_id": 182,
    "skills": "tableau",
    "demand_count": "230",
    "avg_salary": "99288"
  },
  {
    "skill_id": 197,
    "skills": "ssrs",
    "demand_count": "14",
    "avg_salary": "99171"
  },
  {
    "skill_id": 92,
    "skills": "spark",
    "demand_count": "13",
    "avg_salary": "99077"
  },
  {
    "skill_id": 13,
    "skills": "c++",
    "demand_count": "11",
    "avg_salary": "98958"
  },
  {
    "skill_id": 186,
    "skills": "sas",
    "demand_count": "63",
    "avg_salary": "98902"
  },
  {
    "skill_id": 7,
    "skills": "sas",
    "demand_count": "63",
    "avg_salary": "98902"
  },
  {
    "skill_id": 61,
    "skills": "sql server",
    "demand_count": "35",
    "avg_salary": "97786"
  },
  {
    "skill_id": 9,
    "skills": "javascript",
    "demand_count": "20",
    "avg_salary": "97587"
  }
]
*/