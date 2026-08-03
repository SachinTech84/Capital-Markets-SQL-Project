UPDATE Brokers 
SET ParentBrokerId=
CASE 
	WHEN BrokerName='Goldman Sachs' THEN NULL 
	WHEN BrokerName='Goldman Sachs India' THEN 'Goldman Sachs'
	WHEN BrokerName='Morgan Stanley' THEN NULL
	WHEN BrokerName='Morgan Stanley Singapore' THEN 'Morgan Stanley'

END 
WHERE BrokerName in ('Goldman Sachs','Goldman Sachs India','Morgan Stanley','Morgan Stanley Singapore')

