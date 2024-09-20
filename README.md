## Folder Structure

### Analysis

Contains the implementation of the model, validated by comparison with results reported in the reference paper.

### Neuromodulation

Includes the implementation of a current applied at the neuronal level to investigate the optimal waveform for neuromodulation.

### Mutation

Features the implementation of a genetic defect (FHM3 mutation) linked to migraine with aura, reviewing its implications on cortical spreading depression (CSD).

## HH

This folder includes a simple Hodgkin-Huxley neuron model based on the original paper: [Hodgkin-Huxley Model](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC1392413/). It is used for visualizations in the first chapter of the thesis.

## BARRETO

Contains a conductance-based neuron model extended with ion concentration dynamics, based on the paper by Barreto et al.: [Barreto et al.](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3101327/). The synaptic input, used to test the neuron's response during neuromodulation, is modeled as described in: [Synaptic Input Model](https://pubmed.ncbi.nlm.nih.gov/26867734/). The genetic defect (FHM mutation) is modeled as in: [FHM Mutation Model](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4017887/).

## HUGUET

Includes a neuron-astrocyte network model and the functioning of gap junctions, based on the paper by Huguet et al.: [Huguet et al.](https://pubmed.ncbi.nlm.nih.gov/27463146/). The genetic defect (FHM mutation) is modeled as in: [FHM Mutation Model](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4017887/).

## CONTE

Implements a neuron-astrocyte pair, including sodium-glutamate transporters and calcium concentration dynamics, based on the paper by Conte et al.: [Conte et al.](https://pubmed.ncbi.nlm.nih.gov/29210004/). Another implementation of this model using the XPP software can be found at: [XPP Model](https://senselab.med.yale.edu/ModelDB/showmodel.cshtml?model=235377&file=/terman-ModelDB/#tabs-2). For the Jfluxes/serca functions, refer to the reference paper for a better understanding of the parameters: [Jfluxes/SERCA Functions](https://www.sciencedirect.com/science/article/abs/pii/S0022519300922926?via%3Dihub).
