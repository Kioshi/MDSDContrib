/*
 * generated by Xtext 2.16.0
 */
package dk.sdu.martinek.ui

import org.eclipse.xtend.lib.annotations.FinalFieldsConstructor
import org.eclipse.xtext.ide.editor.syntaxcoloring.ISemanticHighlightingCalculator
import org.eclipse.xtext.ide.editor.syntaxcoloring.DefaultSemanticHighlightingCalculator
import dk.sdu.martinek.services.MyDSLGrammarAccess;
import org.eclipse.xtext.resource.XtextResource
import org.eclipse.xtext.ide.editor.syntaxcoloring.IHighlightedPositionAcceptor
import org.eclipse.xtext.util.CancelIndicator
import org.eclipse.xtext.nodemodel.ICompositeNode
import org.eclipse.xtext.nodemodel.INode
import javax.inject.Inject
import org.eclipse.xtext.ui.editor.syntaxcoloring.DefaultHighlightingConfiguration
import org.eclipse.xtext.nodemodel.impl.CompositeNodeWithSemanticElement
import dk.sdu.martinek.myDSL.impl.EntityImpl

/**
 * Use this class to register components to be used within the Eclipse IDE.
 */
@FinalFieldsConstructor
class MyDSLUiModule extends AbstractMyDSLUiModule
{	
	def Class<? extends ISemanticHighlightingCalculator> bindISemanticHighlightingCalculator() {
		MyDslSemanticHighlightingCalculator
	}
}

public class MyDslSemanticHighlightingCalculator extends DefaultSemanticHighlightingCalculator
{
	@Inject	MyDSLGrammarAccess ga;

	// Color first word of entity (Widget identifier)	
	override void provideHighlightingFor(XtextResource resource, IHighlightedPositionAcceptor acceptor, CancelIndicator cancelIndicator)
	{
		val rootNode = resource.getParseResult().getRootNode();
		for (INode node : rootNode.getAsTreeIterable()) {
			if (node instanceof CompositeNodeWithSemanticElement)
			{
				node.firstChild.grammarElement;
				if (node.semanticElement instanceof EntityImpl)
					acceptor.addPosition(node.firstChild.getOffset(), node.firstChild.getLength(), DefaultHighlightingConfiguration.KEYWORD_ID);
			}
		}
		super.provideHighlightingFor(resource, acceptor, cancelIndicator);
	}
}
