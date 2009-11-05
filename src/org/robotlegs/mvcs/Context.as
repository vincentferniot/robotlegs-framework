/*
 * Copyright (c) 2009 the original author or authors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package org.robotlegs.mvcs
{
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;
	
	import org.robotlegs.base.CommandMap;
	import org.robotlegs.base.ContextBase;
	import org.robotlegs.base.EventMap;
	import org.robotlegs.base.MediatorMap;
	import org.robotlegs.base.ViewMap;
	import org.robotlegs.core.ICommandMap;
	import org.robotlegs.core.IContext;
	import org.robotlegs.core.IEventMap;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IMediatorMap;
	import org.robotlegs.core.IReflector;
	import org.robotlegs.core.IViewMap;
	
	/**
	 * Abstract MVCS <code>IContext</code> implementation
	 */
	public class Context extends ContextBase implements IContext
	{
		protected var _commandMap:ICommandMap;
		protected var _mediatorMap:IMediatorMap;
		protected var _viewMap:IViewMap;
		
		/**
		 * Abstract Context Implementation
		 *
		 * <p>Extend this class to create a Framework or Application context</p>
		 *
		 * @param contextView The root view node of the context. The context will listen for ADDED_TO_STAGE events on this node
		 * @param autoStartup Should this context automatically invoke it's <code>startup</code> method when it's <code>contextView</code> arrives on Stage?
		 */
		public function Context(contextView:DisplayObjectContainer = null, autoStartup:Boolean = true)
		{
			super(contextView, autoStartup);
		}
		
		// API ////////////////////////////////////////////////////////////////
		
		/**
		 * The <code>IContext</code>'s <code>DisplayObjectContainer</code>
		 *
		 * @param view The <code>DisplayObjectContainer</code> to use as scope for this <code>IContext</code>
		 */
		override public function set contextView(value:DisplayObjectContainer):void
		{
			if (_contextView != value)
			{
				_contextView = value;
				mediatorMap.contextView = value;
				viewMap.contextView = value;
				mapInjections();
				checkAutoStartup();
			}
		}
		
		// FPI ////////////////////////////////////////////////////////////////
		
		/**
		 * The <code>ICommandMap</code> for this <code>IContext</code>
		 */
		protected function get commandMap():ICommandMap
		{
			return _commandMap || (_commandMap = new CommandMap(eventDispatcher, injector, reflector));
		}
		
		/**
		 * The <code>ICommandMap</code> for this <code>IContext</code>
		 */
		protected function set commandMap(value:ICommandMap):void
		{
			_commandMap = value;
		}
		
		/**
		 * The <code>IMediatorMap</code> for this <code>IContext</code>
		 */
		protected function get mediatorMap():IMediatorMap
		{
			return _mediatorMap || (_mediatorMap = new MediatorMap(contextView, injector, reflector));
		}
		
		/**
		 * The <code>IMediatorMap</code> for this <code>IContext</code>
		 */
		protected function set mediatorMap(value:IMediatorMap):void
		{
			_mediatorMap = value;
		}
		
		/**
		 * The <code>IMediatorMap</code> for this <code>IContext</code>
		 */
		protected function get viewMap():IViewMap
		{
			return _viewMap || (_viewMap = new ViewMap(contextView, injector, reflector));
		}
		
		/**
		 * The <code>IViewMap</code> for this <code>IContext</code>
		 */
		protected function set viewMap(value:IViewMap):void
		{
			_viewMap = value;
		}
		
		// HOOKS ////////////////////////////////////////////////////////////////
		
		/**
		 * Injection Mapping Hook
		 *
		 * <p>Override this in your Framework context to change the default configuration</p>
		 *
		 * <p>Beware of collisions in your container</p>
		 */
		override protected function mapInjections():void
		{
			injector.mapValue(IReflector, reflector);
			injector.mapValue(IInjector, injector);
			injector.mapValue(IEventDispatcher, eventDispatcher);
			injector.mapValue(DisplayObjectContainer, contextView);
			injector.mapValue(ICommandMap, commandMap);
			injector.mapValue(IMediatorMap, mediatorMap);
			injector.mapValue(IViewMap, viewMap);
			injector.mapClass(IEventMap, EventMap);
		}
	
	
	}
}