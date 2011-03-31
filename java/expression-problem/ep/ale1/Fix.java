package ep.ale1;

interface EvalExpF extends EvalExp<EvalExpF> {}                  

class EvalLitF extends EvalLit<EvalExpF> implements EvalExpF {}  
                                                                    
class EvalAddF extends EvalAdd<EvalExpF> implements EvalExpF {}  
