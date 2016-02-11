{-# LANGUAGE OverloadedStrings #-}
module Main where

import Network.HTTP.ReverseProxy
import Data.Conduit.Network
import System.Environment
import Data.ByteString.Char8

main :: IO ()
main = do
  myApproot <- pack <$> getEnv "APPROOT"
  rawhost <- pack <$> getEnv "host"
  rawport <- read <$> getEnv "port"
  appPort <- read <$> getEnv "PORT"
  runTCPServer (serverSettings appPort "127.0.0.1") $ \appData ->
    rawProxyTo
        (\_headers -> return $ Right $ ProxyDest rawhost rawport)
        appData
