Explanation of different folders, which include the following subfolders:   
-Analysis: Implementation of the model, to validate by comparison with results reported in reference paper  
-Neuromodulation: Implementation of a current applied at the neuronal level, to investigate the optimal waveform for neuromodulation  
-Mutation: Implementation of a genetic defect (FHM3 mutation) linked to migraine with aura, to review its implications on CSD.  

## HH
Includes a simple Hodgkin-Huxley neuron model, based on the original paper: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC1392413/  
Used for visualizations in first chapter of thesis.  

## BARRETO
Includes a conductance-based neuron model, extended with ion concentration dynamics.   
Based on the paper of Barreto et al.: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3101327/  
The synaptic input (to test the neuron's response to synaptic input during neuromodulation) is modeled as in: https://pubmed.ncbi.nlm.nih.gov/26867734/  
The genetic defect (FHM mutation) is modeled as in: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4017887/  

## HUGUET
Includes a neuron-astrocyte network model and the functioning of gap junctions.  
Based on the paper of Huguet et al.: https://pubmed.ncbi.nlm.nih.gov/27463146/  
The genetic defect (FHM mutation) is modeled as in: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4017887/  

## CONTE
Implementation of a neuron-astrocyte pair, including sodium-glutamate transporters and calcium concentration dynamics.  
Based on the paper of Conte et al.: https://pubmed.ncbi.nlm.nih.gov/29210004/  
Another implementation of this model (using the XPP software) can be found at: https://senselab.med.yale.edu/ModelDB/showmodel.cshtml?model=235377&file=/terman-ModelDB/#tabs-2  
For the Jfluxes/serca functions, the reference paper is recommended to better understand the parameters: https://www.sciencedirect.com/science/article/abs/pii/S0022519300922926?via%3Dihub  

