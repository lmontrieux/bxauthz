/*
 * generated by Xtext
 */
package jp.ac.nii.prg.bxauthz.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IGenerator
import org.eclipse.xtext.generator.IFileSystemAccess
import jp.ac.nii.prg.bxauthz.bxAuthZ.Policy

import static extension jp.ac.nii.prg.bxauthz.utils.BxAuthZModelUtils.*
import jp.ac.nii.prg.bxauthz.bxAuthZ.Rule
import jp.ac.nii.prg.bxauthz.bxAuthZ.Condition

/**
 * Generates code from your model files on save.
 * 
 * see http://www.eclipse.org/Xtext/documentation.html#TutorialCodeGeneration
 */
class BxAuthZGenerator implements IGenerator {
	
	override void doGenerate(Resource resource, IFileSystemAccess fsa) {
		for (policy:resource.allContents.toIterable.filter(typeof(Policy))) {
			fsa.generateFile("filters/" + policy.name + ".fwd.xq", policy.compileFwd)
			fsa.generateFile("filters/" + policy.name + ".bwd.xq", policy.compileBwd)
		}
	}
	
	/**
	 * @TODO: fix outer element name
	 */
	def compileFwd(Policy policy) {
		'''
		(: function declarations :)
		«declareFunctions()»
		
		(: external variables declarations :)
		declare variable $view external
		
		(: ABAC attributes declarations :)
		«policy.declareReadAttributes»
		
		(: sanitizing view :)
		(: building the set of elements that can be read :)
		«policy.buildReadResourceSet»
		
		(: filtering the view :)
		«fwdFilter("calview")»
		'''
	}
	
	def compileBwd(Policy policy) {
		'''
		(: function declarations :)
		
		(: external variables declarations :)
		declare variable $orig external
		declare variable $mod external
		
		(: ABAC attributes declarations :)
		«policy.declareWriteAttributes»
		
		(: filtering updated view :)
		'''
	}
	
	private def declareFunctions() {
		'''
		declare namespace functx = "http://www.functx.com";
		declare function functx:is-node-among-descendants($node as node()?, $seq as node()* )  as xs:boolean {
			some $nodeInSeq in $seq/descendant-or-self::*/(.|@*)
			satisfies $nodeInSeq is $node
		};
		
		declare function functx:is-node-in-sequence($node as node()?, $seq as node()* )  as xs:boolean {
			some $nodeInSeq in $seq satisfies $nodeInSeq is $node
		};
		
		declare function functx:is-ancestor($node1 as node(), $node2 as node() )  as xs:boolean {
			exists($node1 intersect $node2/ancestor::node())
		};
		
		(: returns true if a node is an ancestor of at least one sequence element :)
		declare function local:is-ancestor-seq($node as node(), $sequence as node()*) as xs:boolean {
			some $candidate in $sequence
			satisfies(functx:is-ancestor($node, $candidate))
		};
		
		declare function local:filter-elements-path($element as element(), $paths as element()*) as element() {
			element {node-name($element) }
			{$element/@*,
				for $child in $element/node()
					return if ($child instance of element())
						then if (functx:is-node-in-sequence($child, $paths))
							then local:copy($child)
						else (if (local:is-ancestor-seq($child, $paths))
							then local:filter-elements-path($child, $paths)
							else ())
					else $child
			}
		};
		
		(: copies a node with all its contents and descendents :)
		declare function local:copy($element as element()) as element() {
			element { node-name($element)}
			{$element/@*,
				for $child in $element/node()
					return if ($child instance of element())
						then local:copy($child)
					else $child
			}
		};
		'''
	}
	
	private def fwdFilter(String outer) {
		'''
		{ 
			local:filter-elements-path($view/«outer», local:resources())
		}
		'''
	}
	
	private def declareReadAttributes(Policy policy) {
		'''
		«FOR attribute:policy.getReadAttributes»
		declare variable $«attribute» external
		«ENDFOR»
		'''
	}
	
	private def declareWriteAttributes(Policy policy) {
		'''
		«FOR attribute:policy.getWriteAttributes»
		declare variable $«attribute» external
		«ENDFOR»
		'''
	}
	
	private def buildReadResourceSet(Policy policy) {
		'''
		declare function local:resources() as element()* {
		$view/(«FOR rule:policy.getReadRules SEPARATOR '|'»
		«rule.buildReadResourceSet»
		«ENDFOR»)
		};
		'''
	}
	
	private def buildReadResourceSet(Rule rule) {
		'''
		«FOR resource:rule.resources SEPARATOR '|'»
		«resource.name»
		«ENDFOR»
		'''
	}
	
	private def buildConditions(Rule rule) {
		'''
		«FOR condition:rule.conditions SEPARATOR 'and'»
		«condition.buildCondition»
		«ENDFOR»
		'''
	}
	
	private def buildCondition(Condition condition) {
		'''
		(«condition»)
		'''
	}
	
	private def buildSelection(Rule rule) {
		'''
		'''
	}
}