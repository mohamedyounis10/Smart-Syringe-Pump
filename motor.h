class CustomStepper {
  public:
    int inputPins[4];
    unsigned long stepDelayMicros; 

    CustomStepper(int In1, int In2, int In3, int In4) {
      this->inputPins[0] = In1;
      this->inputPins[1] = In2;
      this->inputPins[2] = In3;
      this->inputPins[3] = In4;
      for(int i = 0; i < 4; i++){
        pinMode(this->inputPins[i], OUTPUT);
      }
      stepDelayMicros = 1000; 
    }

    void setStepDelay(unsigned long delayMicros) {
      this->stepDelayMicros = delayMicros;
    }

    void stop() {
      for (int i = 0; i < 4; i++) {
        digitalWrite(this->inputPins[i], LOW);
      }
    }

    void step(long noOfSteps) { 
      bool sequence[][4] = {
        {LOW, LOW, LOW, HIGH },
        {LOW, LOW, HIGH, HIGH},
        {LOW, LOW, HIGH, LOW },
        {LOW, HIGH, HIGH, LOW},
        {LOW, HIGH, LOW, LOW },
        {HIGH, HIGH, LOW, LOW},
        {HIGH, LOW, LOW, LOW },
        {HIGH, LOW, LOW, HIGH}
      };
      
      int factor = (noOfSteps >= 0) ? 1 : -1;    
      long absoluteSteps = abs(noOfSteps);    
      
      for(long s = 0; s < absoluteSteps; s++) {
         delayMicroseconds(stepDelayMicros);
         
         int stepIndex = s % 8; 
         if (factor == -1) stepIndex = 7 - stepIndex; 

         for(int inputCount = 0; inputCount < 4; inputCount++){
             digitalWrite(this->inputPins[inputCount], sequence[stepIndex][inputCount]);
         }
      }
    }
};