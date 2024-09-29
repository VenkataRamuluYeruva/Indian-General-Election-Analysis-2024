-- database creation
create database Indian_Elections

-- use database
use Indian_Elections

-- view the list of available tables
SELECT table_name FROM information_schema.tables WHERE table_type = 'BASE TABLE';

-- Total Seats
select count(distinct Parliament_Constituency)as Total_seats from Constituencywise_Results

--What are the total number of seats available for elections in each state
select
	s.state as State_name,
	count(cr.Constituency_Id) as total_seats
from
	Constituencywise_Results cr join Statewise_Results sr
	on cr.Parliament_Constituency=sr.Parliament_Constituency
	join States s on s.State_ID=sr.State_ID
	group by s.State
	order by s.State

-- Total seats won by NDA Alliance

select party,won from Partywise_Results where
party in ('Bharatiya Janata Party - BJP', 
        'Telugu Desam - TDP', 
		'Janata Dal  (United) - JD(U)',
        'Shiv Sena - SHS', 
        'AJSU Party - AJSUP', 
        'Apna Dal (Soneylal) - ADAL', 
        'Asom Gana Parishad - AGP',
        'Hindustani Awam Morcha (Secular) - HAMS', 
        'Janasena Party - JnP', 
		'Janata Dal  (Secular) - JD(S)',
        'Lok Janshakti Party(Ram Vilas) - LJPRV', 
        'Nationalist Congress Party - NCP',
        'Rashtriya Lok Dal - RLD', 
        'Sikkim Krantikari Morcha - SKM'
) order by Won

-- Total seats won by I.N.D.I.A Alliances
select
	sum(
		case
			when party in(
				'Indian National Congress - INC',
                'Aam Aadmi Party - AAAP',
                'All India Trinamool Congress - AITC',
                'Bharat Adivasi Party - BHRTADVSIP',
                'Communist Party of India  (Marxist) - CPI(M)',
                'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
                'Communist Party of India - CPI',
                'Dravida Munnetra Kazhagam - DMK',
                'Indian Union Muslim League - IUML',
                'Nat`Jammu & Kashmir National Conference - JKN',
                'Jharkhand Mukti Morcha - JMM',
                'Jammu & Kashmir National Conference - JKN',
                'Kerala Congress - KEC',
                'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
                'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
                'Rashtriya Janata Dal - RJD',
                'Rashtriya Loktantrik Party - RLTP',
                'Revolutionary Socialist Party - RSP',
                'Samajwadi Party - SP',
                'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
                'Viduthalai Chiruthaigal Katchi - VCK')
			then won
		end) as total_seats from Partywise_Results

-- Seats won by I.N.D.I.A alliance parties
select party,won from Partywise_Results where party in ( 'Indian National Congress - INC',
                'Aam Aadmi Party - AAAP',
                'All India Trinamool Congress - AITC',
                'Bharat Adivasi Party - BHRTADVSIP',
                'Communist Party of India  (Marxist) - CPI(M)',
                'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
                'Communist Party of India - CPI',
                'Dravida Munnetra Kazhagam - DMK',
                'Indian Union Muslim League - IUML',
                'Nat`Jammu & Kashmir National Conference - JKN',
                'Jharkhand Mukti Morcha - JMM',
                'Jammu & Kashmir National Conference - JKN',
                'Kerala Congress - KEC',
                'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
                'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
                'Rashtriya Janata Dal - RJD',
                'Rashtriya Loktantrik Party - RLTP',
                'Revolutionary Socialist Party - RSP',
                'Samajwadi Party - SP',
                'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
                'Viduthalai Chiruthaigal Katchi - VCK'
) order by Won

-- Add Extra column to the partywise_results table of Alliance_Party
alter table Partywise_results add Alliance_Party varchar(20)

-- update that alliace_party column with specific alliance party

update Partywise_Results set Alliance_Party='NDA' where party in 
('Bharatiya Janata Party - BJP', 
        'Telugu Desam - TDP', 
		'Janata Dal  (United) - JD(U)',
        'Shiv Sena - SHS', 
        'AJSU Party - AJSUP', 
        'Apna Dal (Soneylal) - ADAL', 
        'Asom Gana Parishad - AGP',
        'Hindustani Awam Morcha (Secular) - HAMS', 
        'Janasena Party - JnP', 
		'Janata Dal  (Secular) - JD(S)',
        'Lok Janshakti Party(Ram Vilas) - LJPRV', 
        'Nationalist Congress Party - NCP',
        'Rashtriya Lok Dal - RLD', 
        'Sikkim Krantikari Morcha - SKM'
)

update Partywise_Results set Alliance_Party='INDIA' WHERE party in
( 'Indian National Congress - INC',
                'Aam Aadmi Party - AAAP',
                'All India Trinamool Congress - AITC',
                'Bharat Adivasi Party - BHRTADVSIP',
                'Communist Party of India  (Marxist) - CPI(M)',
                'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
                'Communist Party of India - CPI',
                'Dravida Munnetra Kazhagam - DMK',
                'Indian Union Muslim League - IUML',
                'Nat`Jammu & Kashmir National Conference - JKN',
                'Jharkhand Mukti Morcha - JMM',
                'Jammu & Kashmir National Conference - JKN',
                'Kerala Congress - KEC',
                'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
                'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
                'Rashtriya Janata Dal - RJD',
                'Rashtriya Loktantrik Party - RLTP',
                'Revolutionary Socialist Party - RSP',
                'Samajwadi Party - SP',
                'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
                'Viduthalai Chiruthaigal Katchi - VCK'
)

		-- update remaining parties as others
update Partywise_Results set Alliance_Party='OTHER' 
where Alliance_party is null

-- Which party alliance(NDA,INDIA,OTHER) won the most seats across all states
select alliance_party,sum(won) as total_seats from Partywise_Results
group by alliance_party order by total_seats desc

-- Winning candidate's name,their party name,total votes and the margin of victory 
-- for a specific state and constituency

select 
	cr.winning_candidate,p.party,p.alliance_party,cr.Total_Votes,cr.margin,
	s.state,cr.constituency_name
from 
	Constituencywise_Results cr join Partywise_Results p on cr.Party_ID=p.Party_ID
	join Statewise_Results sr on sr.Parliament_Constituency=cr.Parliament_Constituency
	join States s on s.State_ID=sr.State_ID

-- What is the distribution of EVM votes vs Postal votes for candidates in a specific constituency.
select 
	cd.Candidate,cr.Constituency_Name,cd.EVM_Votes,cd.Postal_Votes,cr.Total_Votes
from
	Constituencywise_Details cd join Constituencywise_Results cr
	on cd.Constituency_ID=cr.Constituency_ID

-- which parties won the most seats in a state and how may seats did each party win?
select
	s.State,p.party,count(*) as total_seats
from
	Partywise_Results p join Constituencywise_Results cr on p.Party_ID=cr.Party_ID
	join Statewise_Results sr on sr.Parliament_Constituency=cr.Parliament_Constituency
	join States s on s.State_ID=sr.State_ID
	group by s.State,p.party
	order by s.state,total_seats desc

-- what is the total number of seats won by each party alliance (NDA,INDIA,other)
-- in each state for the india elections 2024
select 
	s.state,p.alliance_party,count(*)as total_seats
from
	Partywise_Results p join Constituencywise_Results cr on cr.Party_ID=p.Party_ID
	join Statewise_Results sr on sr.Parliament_Constituency=cr.Parliament_Constituency
	join States s on s.State_ID=sr.State_ID
	group by s.State,p.Alliance_Party
	order by s.State,total_seats desc

-- which candidate received the highest number of EVM votes in each constituency
select candidate,constituency_name,Evm_votes
from
	(select 
		cd.Candidate,cr.Constituency_name,cd.EVM_Votes as Evm_votes,
		RANK() over(partition by cr.constituency_name order by Evm_votes) as rank
	from 
		Constituencywise_Details cd join Constituencywise_Results cr
		on cd.Constituency_ID=cr.Constituency_ID) as t1
where rank=1
order by Evm_votes desc

-- which candidate won and which candidate was runner-up in 
-- each constituency of state for the 2024 elections
select 
	s.state,cr.Constituency_Name,
	sr.Leading_Candidate as Won_Candidate,
	sr.Trailing_Candidate as Runner_Up_Candiate
from
	Constituencywise_Results cr join Statewise_Results sr 
	on sr.Parliament_Constituency=cr.Parliament_Constituency
	join States s on s.State_ID=sr.State_ID

-- For the state of Maharashtra, what are the total number of seats,total number of candidates,
-- total no of parties, total votes(including Evm and postal) and
-- the breakdown of evm and postal votes

select  
	count(distinct cr.Constituency_Name)as total_seats,
	count(distinct cd.Candidate) as total_Candidates,
	count(distinct cd.Party) as total_parties,
	sum(cd.Total_Votes) as total_votes,
	sum(cd.EVM_Votes) as total_evm_votes,
	sum(cd.Postal_Votes) as total_postal_votes
from
	Constituencywise_Details cd join Constituencywise_Results cr on cd.Constituency_ID=cr.Constituency_ID
	join Statewise_Results sr on sr.Parliament_Constituency=cr.Parliament_Constituency
	join States s on s.State_ID=sr.State_ID and s.State='maharashtra'
