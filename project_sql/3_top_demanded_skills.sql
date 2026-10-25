/*
ทักษะอะไรที่เป็นที่ต้องการมากที่สุดสำหรับ Data Analyst

- เชื่อมตารางประกาศงานด้วย INNER JOIN แบบเดียวกับคิวรีที่ 2
- หา 5 ทักษะที่เป็นที่ต้องการมากที่สุดสำหรับ Data Analyst
- ใช้ข้อมูลจากประกาศงานทั้งหมด
- ทำไมถึงทำ? เพื่อดึง 5 ทักษะที่ตลาดงานต้องการสูงสุด

    ช่วยให้ผู้หางานเห็นว่าควรพัฒนาทักษะไหนให้ได้เปรียบที่สุด
*/

SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' 
    AND job_work_from_home = True 
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;

/*
สรุปทักษะที่เป็นที่ต้องการมากที่สุดสำหรับ Data Analyst ในปี 2023
SQL และ Excel ยังคงเป็นพื้นฐานสำคัญ ผู้ที่อยากเป็น Data Analyst ต้องมีทักษะด้านการประมวลผลข้อมูลและการใช้สเปรดชีตที่แน่นก่อน
เครื่องมือเขียนโปรแกรมและแสดงภาพข้อมูลอย่าง Python, Tableau และ Power BI ก็จำเป็นไม่แพ้กัน สะท้อนว่าทักษะด้านเทคนิคสำคัญขึ้นเรื่อยๆ ทั้งในการเล่าเรื่องด้วยข้อมูลและการช่วยตัดสินใจ

[
  {
    "skills": "sql",
    "demand_count": "7291"
  },
  {
    "skills": "excel",
    "demand_count": "4611"
  },
  {
    "skills": "python",
    "demand_count": "4330"
  },
  {
    "skills": "tableau",
    "demand_count": "3745"
  },
  {
    "skills": "power bi",
    "demand_count": "2609"
  }
]
*/