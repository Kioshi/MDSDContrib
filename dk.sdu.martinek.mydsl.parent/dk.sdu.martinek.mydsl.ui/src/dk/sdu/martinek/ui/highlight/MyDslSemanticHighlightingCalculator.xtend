package dk.sdu.martinek.ui.highlight

import dk.sdu.martinek.services.MyDSLGrammarAccess
import javax.inject.Inject
import org.eclipse.xtext.ide.editor.syntaxcoloring.DefaultSemanticHighlightingCalculator
import org.eclipse.xtext.ide.editor.syntaxcoloring.IHighlightedPositionAcceptor
import org.eclipse.xtext.nodemodel.INode
import org.eclipse.xtext.resource.XtextResource
import org.eclipse.xtext.util.CancelIndicator

class MyDslSemanticHighlightingCalculator extends DefaultSemanticHighlightingCalculator
{
	@Inject	MyDSLGrammarAccess ga;

	
	override provideHighlightingFor(XtextResource resource, IHighlightedPositionAcceptor acceptor, CancelIndicator cancelIndicator) {
		val rootNode = resource.getParseResult().getRootNode();
		
		for (INode node : rootNode.getAsTreeIterable()) { 
				switch node.grammarElement
				{
					case ga.entityAccess.refWidgetCrossReference_0_0:
						acceptor.addPosition(node.offset, node.length, MyDSLHighlightingConfiguration.WIDGET_TYPE_ID)
					case ga.widgetAccess.nameIDTerminalRuleCall_1_0:
						acceptor.addPosition(node.offset, node.length, MyDSLHighlightingConfiguration.WIDGET_ID)
					case ga.entityAccess.parentEntityCrossReference_2_1_0,
					case ga.attributeValueAccess.myEntityIdentifierAction_3_0,
					case ga.entityAccess.nameIDTerminalRuleCall_1_0,
					case ga.layoutAccess.refEntityCrossReference_0_0:
						acceptor.addPosition(node.offset, node.length, MyDSLHighlightingConfiguration.ENTITY_ID)
					case ga.attributeAccess.refPropertyCrossReference_0_0,
					case ga.propertyAccess.nameIDTerminalRuleCall_2_0:
						acceptor.addPosition(node.offset, node.length, MyDSLHighlightingConfiguration.PROPERTY_ID)
					case ga.widgetsAccess.widgetsKeyword_1,
					case ga.entitiesAccess.elementsKeyword_1,
					case ga.layoutsAccess.layoutKeyword_1,
					case ga.headersAccess.headersKeyword_1:
						acceptor.addPosition(node.offset, node.length, MyDSLHighlightingConfiguration.LABEL_ID)
				}
		}
		super.provideHighlightingFor(resource, acceptor, cancelIndicator);
	}
}
