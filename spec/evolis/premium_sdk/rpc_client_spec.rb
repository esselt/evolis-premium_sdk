require 'spec_helper'

module Evolis::PremiumSdk
  RSpec.describe RpcClient do
    let(:resource) { RpcClient.new HOST, PORT }

    it '.make_id return number between 1000000000 and 999999999999' do
      expect(RpcClient.make_id.to_i).to be_between(1000000000, 999999999999)
    end

    it '#new is class Print' do
      expect(resource).to be_kind_of(RpcClient)
    end

    describe '#process_single_response' do
      it 'return result only' do
        json = {
            'id'      => '1',
            'jsonrpc' => '2.0',
            'result'  => 'Only results'
        }
        expect(resource.process_single_response json).to eq(json['result'])
      end

      it 'JSON returned with error raise ServerError' do
        json = {
            'id'      => '1',
            'jsonrpc' => '2.0',
            'error'   => {
                'code'    => 404,
                'message' => 'Not found'
            }
        }
        expect{resource.process_single_response json}.to raise_error(Error::ServerError)
      end

      it 'invalid JSON format raise InvalidResponse' do
        json = {
            'id' => '1',
            'wrong' => '__ERROR__'
        }
        expect{resource.process_single_response json}.to raise_error(Error::InvalidResponse)
      end
    end

    describe '#valid_response?' do
      json = {
          'id'      => '1',
          'jsonrpc' => '2.0',
          'result'  => 'Has result'
      }
      error_json = {
          'id'      => '1',
          'jsonrpc' => '2.0',
          'error'   => {
              'code'    => 404,
              'message' => 'Not found'
          }
      }

      it 'valid json is true' do
        expect(resource.valid_response? json).to be true
      end

      it 'valid error json is true' do
        expect(resource.valid_response? error_json).to be true
      end

      it 'not Hash return false' do
        expect(resource.valid_response? json.to_s).to be false
      end

      it 'worng JSONRPC version return false' do
        expect(resource.valid_response?json.merge('jsonrpc' => '1.0')).to be false
      end

      it 'no id return false' do
        expect(resource.valid_response? json.select { |k,v| k != 'id'}).to be false
      end

      it 'with error and result return false' do
        expect(resource.valid_response? json.merge(error_json)).to be false
      end

      it 'error is not hash' do
        expect(resource.valid_response? error_json.merge('error' => 'String')).to be false
      end

      it 'error has no code' do
        expect(resource.valid_response? error_json['error'].select { |k,v| k != 'code'}).to be false
      end

      it 'error has no message' do
        expect(resource.valid_response? error_json['error'].select { |k,v| k != 'message'}).to be false
      end

      it 'error code is not Fixnum' do
        expect(resource.valid_response? error_json['error']['code'] = '1').to be false
      end

      it 'error message is not String' do
        expect(resource.valid_response? error_json['error']['message'] = 1).to be false
      end
    end
  end
end