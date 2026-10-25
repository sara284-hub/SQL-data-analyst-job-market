#📊 วิเคราะห์ตลาดงาน Data Analyst ด้วย SQL
แนะนำโปรเจกต์

โปรเจกต์นี้ฉันทำเพื่อดูว่าตลาดงาน Data Analyst เป็นยังไงบ้าง โดยโฟกัส 3 เรื่องหลัก คือ 💰 งานที่จ่ายสูงสุด 🔥 ทักษะที่ตลาดต้องการ และ 📈 ทักษะที่ทั้งเป็นที่ต้องการและเงินเดือนดีด้วย

🔍 ดูโค้ด SQL ทั้งหมดได้ที่: โฟลเดอร์ project_sql

ที่มาของโปรเจกต์

ฉันอยากรู้ว่าถ้าจะเป็น Data Analyst ควรเรียนอะไรถึงจะได้เปรียบที่สุด เลยลองใช้ SQL หาคำตอบจากข้อมูลจริง ข้อมูลที่ใช้มาจากคอร์ส SQL Course ซึ่งมีข้อมูลตำแหน่งงาน เงินเดือน สถานที่ และทักษะที่ต้องใช้

คำถามที่อยากตอบ

งาน Data Analyst ที่จ่ายสูงสุดมีอะไรบ้าง?
งานเหล่านั้นต้องใช้ทักษะอะไร?
ทักษะไหนเป็นที่ต้องการมากที่สุด?
ทักษะไหนเงินเดือนสูงที่สุด?
ทักษะไหนคุ้มที่สุดที่ควรเรียน?
เครื่องมือที่ใช้
SQL: ใช้ query ข้อมูลและหาข้อสรุป
PostgreSQL: ระบบจัดการฐานข้อมูล
Visual Studio Code: เขียนและรันโค้ด SQL
Git & GitHub: เก็บเวอร์ชันและแชร์งาน
การวิเคราะห์
1. งาน Data Analyst ที่จ่ายสูงสุด

กรองเฉพาะตำแหน่ง Data Analyst ที่ทำงานรีโมท (Anywhere) และระบุเงินเดือน แล้วเรียงจากสูงไปต่ำ เอา 10 อันดับแรก

sql
SELECT	
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND 
    job_location = 'Anywhere' AND 
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;

สิ่งที่เจอ (ปี 2023):

เงินเดือนต่างกันเยอะ: 10 อันดับแรกอยู่ที่ $184,000 ถึง $650,000 ต่อปี
นายจ้างหลากหลาย: มีทั้ง SmartAsset, Meta และ AT&T แปลว่าไม่ได้กระจุกในอุตสาหกรรมเดียว
ชื่อตำแหน่งไม่เหมือนกัน: ตั้งแต่ Data Analyst ธรรมดาไปจนถึง Director of Analytics
2. ทักษะที่งานเงินเดือนสูงต้องการ

ใช้ CTE ดึง 10 งานจากข้อแรก แล้วเชื่อมกับตารางทักษะ เพื่อดูว่างานเหล่านี้ต้องการอะไร

sql
WITH top_paying_jobs AS (
    SELECT	
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND 
        job_location = 'Anywhere' AND 
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC;

สิ่งที่เจอ: SQL มาอันดับ 1 (8 ครั้ง) ตามด้วย Python (7 ครั้ง) และ Tableau (6 ครั้ง) ส่วน R, Snowflake, Pandas และ Excel ก็มีบ้างลดหลั่นกันไป

3. ทักษะที่ตลาดต้องการมากที่สุด

นับว่าแต่ละทักษะโผล่ในประกาศงานกี่ครั้ง เอา 5 อันดับแรก

sql
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
ทักษะ	จำนวนประกาศงาน
SQL	7,291
Excel	4,611
Python	4,330
Tableau	3,745
Power BI	2,609

สิ่งที่เจอ: SQL กับ Excel ยังเป็นพื้นฐานที่ขาดไม่ได้ ส่วน Python, Tableau และ Power BI ก็สำคัญไม่แพ้กัน เพราะใช้เล่าเรื่องด้วยข้อมูลและช่วยตัดสินใจ

4. ทักษะที่เงินเดือนสูงที่สุด

หาเงินเดือนเฉลี่ยของแต่ละทักษะ เอา 25 อันดับแรก

sql
SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True 
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25;
ทักษะ	เงินเดือนเฉลี่ย ($)
pyspark	208,172
bitbucket	189,155
couchbase	160,515
watson	160,515
datarobot	155,486
gitlab	154,500
swift	153,750
jupyter	152,777
pandas	151,821
elasticsearch	145,000

สิ่งที่เจอ:

Big Data และ Machine Learning: เช่น PySpark, DataRobot, Jupyter, Pandas, NumPy ได้เงินเดือนสูง
สายพัฒนาและ Deployment: เช่น GitLab, Kubernetes, Airflow เพราะงานวิเคราะห์เริ่มทับซ้อนกับงานวิศวกรรมข้อมูล
Cloud: เช่น Elasticsearch, Databricks, GCP ใครเก่งสายนี้มีโอกาสได้เงินเดือนสูงขึ้น
5. ทักษะที่คุ้มที่สุดที่ควรเรียน

รวมข้อ 3 และ 4 เข้าด้วยกัน หาทักษะที่ทั้งมีคนต้องการเยอะและเงินเดือนดี โดยตัดทักษะที่โผล่ไม่เกิน 10 ประกาศออก

sql
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
Skill ID	ทักษะ	จำนวนประกาศงาน	เงินเดือนเฉลี่ย ($)
8	go	27	115,320
234	confluence	11	114,210
97	hadoop	22	113,193
80	snowflake	37	112,948
74	azure	34	111,225
77	bigquery	13	109,654
76	aws	32	108,317
4	java	17	106,906
194	ssis	12	106,683
233	jira	20	104,918

สิ่งที่เจอ:

ภาษาโปรแกรม: Python (236 ประกาศ) และ R (148 ประกาศ) เป็นที่ต้องการสูง แต่เงินเดือนเฉลี่ยอยู่ราว $100,000 เพราะมีคนทำได้เยอะ
Cloud: Snowflake, Azure, AWS, BigQuery มีทั้งความต้องการและเงินเดือนค่อนข้างดี
BI และ Visualization: Tableau (230 ประกาศ) และ Looker (49 ประกาศ) เงินเดือนเฉลี่ยราว $99,000 ถึง $104,000
ฐานข้อมูล: Oracle, SQL Server, NoSQL เงินเดือนเฉลี่ย $97,786 ถึง $104,534
สิ่งที่ฉันได้เรียนรู้
🧩 เขียน query ซับซ้อนขึ้น: เชื่อมหลายตารางได้คล่องขึ้น และใช้ WITH สร้างตารางชั่วคราวเป็น
📊 สรุปข้อมูลด้วย Aggregation: ใช้ GROUP BY ร่วมกับ COUNT() และ AVG() ได้เข้าใจมากขึ้น
💡 แปลงคำถามเป็น SQL: ฝึกแตกโจทย์ให้กลายเป็น query ที่ได้คำตอบจริง
สรุปผล
งานจ่ายสูงสุด: งาน Data Analyst แบบรีโมทมีเงินเดือนห่างกันมาก สูงสุดถึง $650,000
ทักษะของงานจ่ายสูง: SQL เป็นทักษะที่งานเหล่านี้ต้องการมากที่สุด
ทักษะที่ตลาดต้องการ: SQL ยังเป็นอันดับ 1 จึงจำเป็นมากสำหรับคนหางาน
ทักษะเงินเดือนสูง: ทักษะเฉพาะทางอย่าง PySpark และเครื่องมือสาย Big Data ได้ค่าตอบแทนสูงสุด
ทักษะที่คุ้มที่สุด: SQL ทั้งมีคนต้องการเยอะและเงินเดือนดี จึงเป็นทักษะที่ควรเรียนก่อน
ทิ้งท้าย

โปรเจกต์นี้ช่วยให้ฉันเก่ง SQL ขึ้นและเข้าใจตลาดงาน Data Analyst มากขึ้น ผลที่ได้ใช้เป็นแนวทางเลือกทักษะที่จะพัฒนาและวางแผนหางานได้ คนที่อยากเป็น Data Analyst ควรโฟกัสทักษะที่ทั้งมีความต้องการสูงและเงินเดือนดี และต้องเรียนรู้ต่อเนื่องเพราะสายนี้เปลี่ยนเร็วมาก

มีข้อควรทำก่อนเอาไปใช้ 3 อย่างครับ

ตรวจตัวเลขกับผลลัพธ์ของคุณเอง ตัวเลขและตารางทั้งหมดมาจาก README ต้นฉบับ ถ้าจะบอกว่าเป็นงานของคุณ ให้รัน query แล้วเทียบดูว่าตรงกันไหม
ข้อสรุปข้อ 4 ผมแก้ให้ตรงกับตาราง ต้นฉบับเขียนว่า “SVN และ Solidity” ได้เงินเดือนสูงสุด แต่ตารางในเอกสารเดียวกันแสดง PySpark อันดับ 1 ผมเลยใช้ PySpark แทน คุณควรเช็กจากผลที่รันได้จริง
ใส่เครดิตแหล่งข้อมูล ผมคงลิงก์คอร์สของ Luke Barousse ไว้ในส่วนที่มาของโปรเจกต์ เพราะข้อมูลและโครงคำถามมาจากคอร์สนั้น