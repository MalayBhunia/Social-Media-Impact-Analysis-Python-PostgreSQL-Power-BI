
---------------------------------- 📊 SQL Business Questions -------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------

 
--🌍 Country Risk Analysis (4):
---------------------------------------------------------------------------------------------------------------------
-- 1. Top 10 countries with the highest average overall risk score.
	Select country,
		Round(AVG(overall_risk_score)::Numeric, 2) as avg_risk_score
	From social_media_impact
	Group by country
	Order by avg_risk_score desc
	Limit 10;

-- 2. Which countries have high social media usage but low digital wellbeing?
	Select country,
		Round(AVG(social_media_hours)::Numeric, 2) as avg_social_media_hr,
		Round(Avg(digital_wellbeing_score)::Numeric, 2) as avg_digital_wellbeing_score
	From social_media_impact
	Group by country
	Having Avg(social_media_hours) > (select AVG(social_media_hours) From social_media_impact)
	AND
		Avg(digital_wellbeing_score) < (select AVG(digital_wellbeing_score) From social_media_impact)
	Order by avg_social_media_hr Desc;
	
-- 3. Rank countries by mental health risk score within each continent. 
	Select continent,
		country,
		Round(Avg(mental_health_risk_score)::Numeric, 2) as avg_mental_health_risk,
		Dense_rank() over(Partition by continent Order by Avg(mental_health_risk_score) desc) as Country_Rank
	From social_media_impact
	Group by continent, country
	Order by continent, Country_Rank

-- 4. Compare overall risk score with cyberbullying exposure by country.
	Select country,
		Round(Avg(overall_risk_score)::Numeric, 2) as avg_overall_risk_score,
		Round((Avg(cyberbullying_victim)*100)::Numeric, 2) as cyberbullying_rate_pct
	From social_media_impact
	Group by country
	Order by avg_overall_risk_score Desc;


--📱 Social Media Behaviour (4):
-------------------------------------------------------------------------------------------------------------------------------
-- 5. Which is the most popular primary social media platform among teenagers?
	Select 
		primary_platform,
		count(*) as Total_users,
		Round(count(*)*100 /sum(count(*)) over(), 2) as Percentage
	From social_media_impact
	Group by primary_platform
	Order by Total_users Desc;
	
-- 6. Screen time category with the highest average mental health risk.
	Select 
		screen_time_category,
		Round(Avg(mental_health_risk_score)::Numeric, 2) as avg_mental_health_risk
	From social_media_impact
	Group by screen_time_category
	Order by avg_mental_health_risk Desc;
		
-- 7. Compare smartphone dependency across income groups.
	SELECT
    	income_group,
    	ROUND(AVG(smartphone_dependency_score)::numeric, 2) AS avg_smartphone_dependency,
    	DENSE_RANK() OVER(ORDER BY AVG(smartphone_dependency_score) Desc) AS dependency_rank
	FROM social_media_impact
	GROUP BY income_group
	ORDER BY dependency_rank;
		
-- 8. Identify countries where social media addiction is above the global average. (Subquery/CTE)
	Select 
		country,
		Round(Avg(social_media_addiction_score)::Numeric, 2) as avg_addiction_score
	From social_media_impact
	Group by country
	Having Avg(social_media_addiction_score) > (
		Select avg(social_media_addiction_score) 
		From social_media_impact
	    )
	Order by avg_addiction_score Desc;


--🧠 Mental Health Analysis (4):
---------------------------------------------------------------------------------------------------------------------------------------------------
-- 9. Which age groups are most vulnerable to anxiety, depression, and stress?
	Select 
		age_group,
		Round(Avg(anxiety_score)::Numeric, 2) as avg_anxiety_score,
		Round(Avg(depression_score)::Numeric, 2) as avg_depression_score,
		Round(Avg(stress_score)::Numeric, 2) as avg_stress_score,
		Round((Avg(anxiety_score)+Avg(depression_score)+Avg(stress_score))::Numeric / 3, 2) 
		as overall_mental_health_score
	From social_media_impact
	Group by age_group
	Order by Overall_mental_health_score Desc;
	
-- 10. Compare mental health risk across urban and rural teenagers.
	Select 
		urban_rural,
		Round(Avg(mental_health_risk_score)::Numeric, 2) as avg_mental_health_risk,
		ROUND(MIN(mental_health_risk_score)::numeric, 2) AS min_risk,
    	ROUND(MAX(mental_health_risk_score)::numeric, 2) AS max_risk
	From social_media_impact
	Group by urban_rural
	Order by avg_mental_health_risk Desc;
	
-- 11. Identify countries where average sleep hours are below the global average but anxiety is above the global average.
	Select
		country,
		Round(Avg(sleep_hours)::Numeric, 2) as avg_sleep_hours,
		Round(Avg(anxiety_score)::Numeric, 2) as avg_anxiety_score
	From social_media_impact
	Group by country
	Having 
		Avg(sleep_hours) < (Select Avg(sleep_hours) From social_media_impact)
	AND
		Avg(anxiety_score) > (Select Avg(anxiety_score) From social_media_impact)
	Order by avg_anxiety_score Desc, avg_sleep_hours Asc;	


-- 12. Rank regions based on average mental health risk. 
	Select 
		region,
		Round(Avg(mental_health_risk_score)::Numeric, 2) as avg_mental_health_risk_score,
		Dense_rank() Over(Order by Avg(mental_health_risk_score) Desc) as ranking
	From social_media_impact
	Group by region
	Order by avg_mental_health_risk_score Desc;


--🎓 Academic & Lifestyle (4):
------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 13. Which screen time category has the lowest GPA?
	Select 
		screen_time_category,
		Round(Avg(gpa_score)::Numeric, 2) as avg_gpa_score
	From social_media_impact
	Group by screen_time_category
	Order by avg_gpa_score
	Limit 1
	
-- 14. Relationship between family support and academic risk.
	Select
		Case
			When family_support_score >=80 Then 'High Family Support'
			When family_support_score >=60 Then 'Moderate Family Support'
			Else 'Low Family Support'
		End as family_support_lavel,
		Count(*) as total_teenagers,
		Round(Avg(academic_risk_score)::Numeric, 2) as avg_academic_risk_score
	From social_media_impact
	Group by family_support_lavel
	Order by total_teenagers Desc;

	
-- 15. Income groups with the highest homework completion rate.
	Select
		income_group,
		Round(Avg(homework_completion_rate_pct)::Numeric, 2) as avg_homework_completion_pct
	From social_media_impact
	Group by income_group
	Order by avg_homework_completion_pct Desc;
	
-- 16. Identify countries with high academic performance despite high social media usage.
	Select
		country,
		Round(Avg(gpa_score)::Numeric, 2) as avg_gpa_score,
		Round(Avg(social_media_hours)::Numeric, 2) as avg_social_use
	From social_media_impact
	Group by country
	Having
		Avg(gpa_score) > (Select Avg(gpa_score) From social_media_impact)
	And
		Avg(social_media_hours) > (Select Avg(social_media_hours) From social_media_impact)
	Order by 
		avg_gpa_score Desc,
		avg_social_use Desc;


--⚠️ Risk & Digital Wellbeing (4):
----------------------------------------------------------------------------------------------------------------------------------------------
-- 17. Rank countries by digital wellbeing score.
	Select
		country,
		Round(Avg(digital_wellbeing_score)::Numeric, 2) avg_digital_wellbeing_score,
		Dense_rank() Over(Order by Avg(digital_wellbeing_score) Desc) as wellbeing_rank
	From social_media_impact
	Group by country
	Order by wellbeing_rank;
	
-- 18. Compare overall risk across different risk levels.
	Select 
		risk_level,
		count(*) as total_user,
		Round(Avg(overall_risk_score)::Numeric, 2) as avg_risk_score,
		Round((count(*)*100 / sum(count(*)) Over())::Numeric, 2) as risk_score_pct
	From social_media_impact
	Group by risk_level
	Order by total_user Desc;
	
-- 19. Which countries have the highest percentage of problematic social media users?
	Select 
		country,
		Count(*) as total_teenagers,
		Sum(
			Case 
				when problematic_use_flag = 1 Then 1 
				Else 0 
			End) as problematic_users,
		Round(Sum(
			Case 
				when problematic_use_flag = 1 Then 1 
				Else 0 
			End)*100.0 / Count(*), 2) as percentage
	From social_media_impact
	Group by country
	Order by percentage Desc;
	
-- 20. Find teenagers who are in the top 10% of overall risk score within their country.

	With ranked_teenagers as(
		Select 
			record_id,
			country,
			overall_risk_score,
			Dense_rank() Over(Partition by country Order by overall_risk_score Desc) as row_num
		From social_media_impact
	)
	Select record_id,
		country,
		overall_risk_score
	From ranked_teenagers
	Where row_num <= 10
	Order by country, row_num;


