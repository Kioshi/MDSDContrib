package dk.sdu.martinek.ui.highlight
/*
class MyDslUiModule extends AbstractMyDslUiModule {

def Class<? extends ISemanticHighlightingCalculator> bindISemanticHighlightingCalculator() {
MyDslSemanticHighlightingCalculator
}
}

public class MyDslSemanticHighlightingCalculator extends DefaultSemanticHighlightingCalculator{

@Inject
MyDslGrammarAccess ga;

@Override
public void provideHighlightingFor(XtextResource resource, IHighlightedPositionAcceptor acceptor,
CancelIndicator cancelIndicator) {
ICompositeNode rootNode = resource.getParseResult().getRootNode();

for (INode node : rootNode.getAsTreeIterable()) {
if (node.getGrammarElement() == ga.getGreetingAccess().getNameIDTerminalRuleCall_1_0()) {
acceptor.addPosition(node.getOffset(), node.getLength(), DefaultHighlightingConfiguration.KEYWORD_ID);
}
}
super.provideHighlightingFor(resource, acceptor, cancelIndicator);
}

} 
 */